module HasSlug
  extend ActiveSupport::Concern

  included do
    # Slug
    extend FriendlyId
    friendly_id :slug_candidates, use: [:slugged, :finders]

    # Validations
    validates :slug, uniqueness: true

    def slug_candidates
      [
        [:title_cs]
      ]
    end

    def should_generate_new_friendly_id?
      new_record? || slug.blank?
    end
  end
end
