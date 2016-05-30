module Sluggable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: [:slugged, :finders, :SimpleI18n]

    before_create :set_unset_slugs
  end

  private

  def slug_candidates
    [
      [:title]
    ]
  end

  def should_generate_new_friendly_id?
    new_record? || slug.blank?
  end

  def set_unset_slugs
    I18n.available_locales.each do |locale|
      attr_key = [slug, locale].join('_').to_sym
      title_key = ['title', locale].join('_').to_sym
      set_friendly_id(self[title_key], locale) unless self[attr_key]
    end
  end
end
