module MetaHelper
  def meta_title
    title = []
    title << @node.title if @node
    title << I18n.t('meta.title')
    title.join(' | ')
  end

  def meta_description
    @node.description.presence || I18n.t('meta.description')
  rescue
    I18n.t('meta.description')
  end

  def meta_og_title
    @node.title.presence
  rescue
    nil
  end

  def meta_og_description
    meta_description
  end

  def meta_og_image
    image_url 'og_logo.png'
  end

  def meta_og_site_name
    I18n.t('meta.title')
  end
end
