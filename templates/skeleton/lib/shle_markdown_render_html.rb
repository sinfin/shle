class ShleMarkdownRenderHtml < Redcarpet::Render::HTML
  def header(text, header_level)
    id = I18n.transliterate(text).downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
    %Q{<h#{header_level} id="#{id}">#{text}</h#{header_level}>}.html_safe
  end
end
