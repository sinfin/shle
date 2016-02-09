class Image < ActiveRecord::Base
  include Thumbnails

  belongs_to :imageable, polymorphic: true

  dragonfly_accessor :photo
  validates :photo, presence: true

  def landscape?
    photo.present? && photo.width >= photo.height
  end
end
