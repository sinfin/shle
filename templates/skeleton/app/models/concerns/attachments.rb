# encoding: utf-8
module Attachments
  extend ActiveSupport::Concern

  included do
    serialize :thumbnail_sizes, Hash
    dragonfly_accessor :attachment
    validates :attachment, presence: true
    before_validation :reset_thumbnails
  end

  # User w_x_h = 400x250# or similar
  #
  def thumb(w_x_h)
    fail 'You can only thumbnail images.' unless has_attribute? 'thumbnail_sizes'
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
    fail 'You can only thumbnail images.' unless has_attribute? 'thumbnail_sizes'
    attachment.present? && attachment.width >= attachment.height
  end

  private

  def reset_thumbnails
    return unless has_attribute? 'thumbnail_sizes'
    self.thumbnail_sizes = {} if photo_uid_changed?
  end

  def compute_sizes(size)
    fail 'You can only thumbnail images.' unless has_attribute? 'thumbnail_sizes'
    thumbnail = attachment.thumb(size, format: :jpg).encode('jpg', '-quality 90')
    {
      uid: thumbnail.store,
      signature: thumbnail.signature,
      url: thumbnail.url,
      width: thumbnail.width,
      height: thumbnail.height
    }
  end
end
