# encoding: utf-8
module Thumbnails
  extend ActiveSupport::Concern

  included do
    serialize :thumbnail_sizes, Hash
    dragonfly_accessor :photo
    before_validation :reset_thumbnails
  end

  # User w_x_h = 400x250# or similar
  #
  def thumb(w_x_h)
    if thumbnail_sizes[w_x_h]
      ret = OpenStruct.new(thumbnail_sizes[w_x_h])
      ret.url = Dragonfly.app.remote_url_for(ret.uid)
      ret
    else
      GenerateThumbnailJob.perform_later(self, w_x_h)
      sizes = w_x_h.split('x')
      OpenStruct.new(
        uid: nil,
        signature: nil,
        url: "http://dummyimage.com/#{w_x_h}/FFF/000.png&text=Generating…",
        width: sizes[0].to_i,
        height: sizes[1].to_i
      )
    end
  end

  def landscape?
    photo.present? && photo.width >= photo.height
  end

  private

  def reset_thumbnails
    self.thumbnail_sizes = {} if photo_uid_changed?
  end

  def compute_sizes(size)
    thumbnail = photo.thumb(size, format: :jpg).encode('jpg', '-quality 85')
    {
      uid: thumbnail.store,
      signature: thumbnail.signature,
      url: thumbnail.url,
      width: thumbnail.width,
      height: thumbnail.height
    }
  end
end
