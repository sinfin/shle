module FileAttachmentHelper
  def render_file_attachments(attachmentable)
    render partial: 'file_attachments/list', locals: { attachmentable: attachmentable }
  end
end
