class FileAttachment < Attachment
  VALID_FORMATS = %i{application/pdf}

  validates_property :mime_type, of: :attachment, in: VALID_FORMATS,
                     case_sensitive: false,
                     message: I18n.t('dragonfly.invalid_format', formats: VALID_FORMATS.join(', ')),
                     if: :attachment_changed?

  def title
    caption.presence || attachment_name
  end
end
