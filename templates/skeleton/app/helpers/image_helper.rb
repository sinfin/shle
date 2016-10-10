module ImageHelper
  def img_tag_retina(normal, retina, html_options = {})
    html_options.merge!({
      srcset: "#{URI.encode(normal)} 1x, #{URI.encode(retina)} 2x"
    })
    image_tag URI.encode(normal), html_options
  end

  def img_tag_semi_retina(normal, retina, html_options = {})
    html_options.merge!({
      srcset: "#{URI.encode(normal)} 1x, #{URI.encode(retina)} 1.5x"
    })
    image_tag URI.encode(normal), html_options
  end

  def img_tag_dragonfly(image, size, html_options = {})
    if image.nil?
      msg = "Trying to get a '#{size}' thumbnail of nil."
      defined?(Raven) ? Raven.capture_exception(msg) : logger.error(msg)
      return ''
    end
    if image.attachment.mime_type =~ /svg/
      html_options[:class] = [html_options[:class], 'r-svg-image'].compact.join(' ')
      image_tag image.attachment.url, html_options
    else
      retina_size = size.gsub(/\d+/) { |num| num.to_i*2 }
      img_tag_retina(image.thumb(size).url, image.thumb(retina_size).url, html_options)
    end
  end

  def smart_img(path, html_options = {})
    normal = URI.encode(image_path(path))
    retina = URI.encode(image_path(path.gsub(/(\.\w+)$/, '@2x\1')))
    html_options.merge!({
      srcset: "#{normal} 1x, #{retina} 2x"
    })
    image_tag normal, html_options
  end
end
