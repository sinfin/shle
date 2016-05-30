require 'open-uri'

class YamlFixtureLoader
  def load!(paths)
    paths.each do |path|
      load_path!(path)
    end
  end

  private

  def load_path!(path)
    yaml_data = YAML::load_file(path)
    CollectionLoader.new(yaml_data).load!
  end

  class CollectionLoader
    def initialize(yaml_data)
      @collection = yaml_data.first.second
      @model = yaml_data.keys.first.constantize
    end

    def load!
      @collection.each do |item|
        ModelLoader.new(item, @model).load!
      end
    end
  end

  class ModelLoader
    def initialize(data, model, build_from = nil)
      @data = data
      @model = model
      if build_from
        @instance = build_from.build
      else
        @instance = @model.new
      end
    end

    def load!(should_save = true)
      load_attributes!
      load_attachment!
      load_relations!
      @instance.save! if should_save
      @instance
    end

    private

    def load_attributes!
      columns = @model.column_names & @data.keys - ['attachment']
      columns.each do |column|
        @instance[column] = @data[column]
      end
    end

    def load_attachment!
      return unless @data.keys.include? 'attachment'
      path = @data['attachment']
      if path =~ /http/
        attachment = open(path).read
      else
        attachment = File.new(Rails.root.join(path))
      end
      @instance.attachment = attachment
    end

    def load_relations!
      @model.reflect_on_all_associations.each do |reflection|
        case reflection.class.to_s
        when 'ActiveRecord::Reflection::HasManyReflection'
          load_relations_has_many!(reflection)
        when 'ActiveRecord::Reflection::BelongsToReflection'
          load_relations_belongs_to!(reflection)
        when 'ActiveRecord::Reflection::HasOneReflection'
          load_relations_has_one!(reflection)
        end
      end
    end

    def load_relations_has_many!(reflection)
      column = reflection.plural_name
      return unless @data.keys.include? column
      @data[column].each do |related_item|
        model = ModelLoader.new(related_item,
                                reflection.class_name.constantize,
                                eval("@instance.#{column}")).load!(false)
        eval("@instance.#{column} << model")
      end
    end

    def load_relations_belongs_to!(reflection)
      column = reflection.name.to_s
      return unless @data.keys.include? column
      eval("@instance.#{column} = reflection.class_name.constantize.find_by(@data[column])")
    end

    def load_relations_has_one!(reflection)
      column = reflection.name.to_s
      return unless @data.keys.include? column
      eval("@instance.#{column} = ModelLoader.new(@data[column], reflection.class_name.constantize).load!(false)")
    end
  end
end
