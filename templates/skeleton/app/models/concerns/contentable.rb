module Contentable
  extend ActiveSupport::Concern

  included do
    has_many :content_parts,
             -> { where(contentable_type: 'Contentable') },
             dependent: :destroy,
             foreign_key: :contentable_id
    accepts_nested_attributes_for :content_parts, allow_destroy: true
  end
end
