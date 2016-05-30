class CreateContentParts < ActiveRecord::Migration
  def change
    create_table :content_parts do |t|
      t.integer :contentable_id
      t.string  :contentable_type
      t.text :text_cs
      t.text :text_en
      t.integer :position
      t.string :variant, default: 'default'
      t.boolean :collapsible_chapters, default: false

      t.timestamps null: false
    end

    add_index :content_parts, :contentable_id
    add_index :content_parts, :contentable_type
    add_index :content_parts, :variant
  end
end
