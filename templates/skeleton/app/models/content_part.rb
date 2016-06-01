class ContentPart < ActiveRecord::Base
  include ContentPartVariants

  belongs_to :contentable, polymorphic: true

  has_many :images, class_name: 'Image', as: :attachmentable, foreign_key: :attachmentable_id, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  acts_as_list scope: [:contentable_id, :contentable_type], top_of_list: 0

  translates :text

  validates :text_cs, :text_en,
            presence: true,
            if: -> (part) { part.variant == 'default' && part.images.blank? }
  validates :images,
            presence: true,
            if: -> (part) { part.variant == 'default' && (part.text_cs.blank? || part.text_en.blank?) }

  scope :ordered, -> { order(position: :asc) }
end
