class Node < ActiveRecord::Base
  include Contentable
  include Sluggable

  has_many :file_attachments, class_name: 'FileAttachment', as: :attachmentable, foreign_key: :attachmentable_id, dependent: :destroy
  accepts_nested_attributes_for :file_attachments, allow_destroy: true

  translates :title, :slug, :menu_link

  validates :title_cs, :title_en,
            presence: true

  validates :code,
            presence: true,
            uniqueness: true

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(position: :asc) }

  def content_titles(exclude_non_default = false, max_level = 2, custom_parts = false)
    collection = custom_parts ? custom_parts : content_parts
    titles = collection.ordered.map do |cp|
      next if exclude_non_default && cp.variant != 'default'
      cp.content_titles(max_level)
    end
    titles << I18n.t('file_attachments.list.heading', default: nil) if file_attachments.present?
    titles.flatten.compact
  end
end
