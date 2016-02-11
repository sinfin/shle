class Image < ActiveRecord::Base
  include Thumbnails

  # Relations
  belongs_to :imageable, polymorphic: true

  # Validations
  before_validation :mark_for_destruction_if_blank

  private

  def mark_for_destruction_if_blank
    mark_for_destruction if photo_uid.blank? && photo.blank?
  end
end
