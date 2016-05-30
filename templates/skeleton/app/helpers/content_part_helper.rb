module ContentPartHelper
  def render_content_parts(contentable)
    render partial: "content_parts/index", locals: { contentable: contentable }
  end

  def render_content_part(content_part)
    render partial: "content_parts/#{content_part.variant}", locals: { content_part: content_part }
  end
end
