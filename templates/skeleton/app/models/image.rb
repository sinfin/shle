class Image < ActiveRecord::Base
  include Attachments

  acts_as_list scope: [:imageable_id, :imageable_type], top_of_list: 0

  # Relations
  belongs_to :imageable, polymorphic: true

  # Validations
  before_validation :mark_for_destruction_if_blank

  private

  def mark_for_destruction_if_blank
    mark_for_destruction if attachment_uid.blank? && attachment.blank?
  end
end
