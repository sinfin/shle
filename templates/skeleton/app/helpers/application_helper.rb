module ApplicationHelper
  def heading_id(string)
    I18n.transliterate(string).downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def body_classes
    [
      "r-node-#{@node.class}",
      "r-#{@node.class}-#{@node.code}"
    ].join(' ').downcase
  rescue
    'r-node-generic'
  end

  def float_without_zero(float)
    return float.floor if float == float.floor
    float
  end
end
