module LinksHelper
  def link_to_active(name, path, html_options = {})
    if current_page?(path)
      html_options.merge!({ class: 'r-active' })
    end
    link_to name, path, html_options
  end

  def phone_link(phone)
    [
      'tel:',
      phone.gsub(/\s/, '')
    ].join('')
  end
end
