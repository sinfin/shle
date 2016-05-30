# encoding: utf-8
module Thumbnails
  extend ActiveSupport::Concern

  included do
    serialize :thumbnail_sizes, Hash
    before_validation :reset_thumbnails
  end

  # User w_x_h = 400x250# or similar
  #
  def thumb(w_x_h)
    fail_for_non_images
    if thumbnail_sizes[w_x_h]
      ret = OpenStruct.new(thumbnail_sizes[w_x_h])
      ret.url = Dragonfly.app.remote_url_for(ret.uid)
      ret
    else
      if attachment.mime_type =~ /svg/
        url = attachment.url
      else
        GenerateThumbnailJob.perform_later(self, w_x_h)
        url = "http://dummyimage.com/#{w_x_h}/FFF/000.png&text=Generating…"
      end
      sizes = w_x_h.split('x')
      OpenStruct.new(
        uid: nil,
        signature: nil,
        url: url,
        width: sizes[0].to_i,
        height: sizes[1].to_i
      )
    end
  end

  def landscape?
    fail_for_non_images
    attachment.present? && attachment.width >= attachment.height
  end

  private

  def reset_thumbnails
    fail_for_non_images
    self.thumbnail_sizes = {} if attachment_uid_changed?
  end

  def compute_sizes(size)
    fail_for_non_images
    thumbnail = attachment.thumb(size, format: :jpg).encode('jpg', '-quality 90')
    {
      uid: thumbnail.store,
      signature: thumbnail.signature,
      url: thumbnail.url,
      width: thumbnail.width,
      height: thumbnail.height
    }
  end

  def fail_for_non_images
    fail 'You can only thumbnail images.' unless has_attribute? 'thumbnail_sizes'
  end
end
