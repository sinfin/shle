class ShleMarkdownRenderHtmlNoParagraphs < ShleMarkdownRenderHtml
  def block_html(raw_html)
    raw_html
  end

  def paragraph(text)
    text
  end
end
