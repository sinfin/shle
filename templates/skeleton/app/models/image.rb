class Image < ActiveRecord::Base
  include Thumbnails

  acts_as_list scope: [:imageable_id, :imageable_type], top_of_list: 0

  # Relations
  belongs_to :imageable, polymorphic: true

  # Validations
  before_validation :mark_for_destruction_if_blank

  private

  def mark_for_destruction_if_blank
    mark_for_destruction if photo_uid.blank? && photo.blank?
  end
end
