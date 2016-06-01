# encoding: utf-8
module ActiveAdmin
  module FormHelper
    def admin_image_preview(f)
      f.object.persisted? && f.object.attachment.present? ? f.template.image_tag(f.object.thumb('100x100').url) : f.template.content_tag(:span, t('admin.not-uploaded'))
    end

    def admin_file_preview(f)
      f.object.persisted? && f.object.attachment.present? ? f.template.content_tag(:span, f.object.attachment_name) : f.template.content_tag(:span, t('admin.not-uploaded'))
    end

    def admin_markdown_hint(locale = :cs)
      if locale == :cs
        'Možno používat <a href="https://help.github.com/articles/basic-writing-and-formatting-syntax/" target="_blank">Markdown</a> formátování.'.html_safe
      else
        'You can use the <a href="https://help.github.com/articles/basic-writing-and-formatting-syntax/" target="_blank">Markdown</a> formatting.'.html_safe
      end
    end
  end
end
