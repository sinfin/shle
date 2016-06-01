class GenerateThumbnailJob < ActiveJob::Base
  queue_as :slow

  def perform(image, size)
    return if image.thumbnail_sizes[size]

    image.thumbnail_sizes[size] = compute_sizes(image, size)
    image.update_attributes(thumbnail_sizes: image.thumbnail_sizes)
  end

  private

  def compute_sizes(image, size)
    return if image.thumbnail_sizes[size]

    thumbnail = image.attachment.thumb(size, format: :jpg).encode('jpg', '-quality 85')
    {
      uid: thumbnail.store,
      signature: thumbnail.signature,
      url: thumbnail.url,
      width: thumbnail.width,
      height: thumbnail.height
    }
  end
end
