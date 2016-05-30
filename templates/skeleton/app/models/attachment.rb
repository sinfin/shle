class Attachment < ActiveRecord::Base
  dragonfly_accessor :attachment
  validates :attachment,
            presence: true

  acts_as_list scope: [:attachmentable_id, :attachmentable_type], top_of_list: 0

  belongs_to :attachmentable, polymorphic: true

  before_validation :mark_for_destruction_if_blank

  translates :caption

  private

  def mark_for_destruction_if_blank
    mark_for_destruction if attachment_uid.blank? && attachment.blank?
  end
end
