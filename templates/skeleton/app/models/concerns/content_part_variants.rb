module ContentPartVariants
  extend ActiveSupport::Concern

  VARIANTS = %w(default).freeze

  included do
    validates :variant,
              inclusion: { in: VARIANTS }

    scope :default_variant, -> { where(variant: 'default') }
    scope :funds_variant, -> { where(variant: 'funds') }
  end

  module ClassMethods
    def variants
      VARIANTS
    end
  end

  def default?
    variant == 'default'
  end

  def variant_data
    # case variant
    # when 'people'
    #   Person.published.ordered
    # end
  end

  def content_titles(max_level)
    case variant
    when 'default'
      return nil if text.blank?
      pattern = /^\s*\#{1,#{max_level}}([^#\n]+)/
      text_titles = text.scan(pattern).flatten.map(&:strip)
    else
      [I18n.t("content_parts.#{variant}.heading", default: nil)]
    end
  end
end
