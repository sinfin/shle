class Page < Node
  acts_as_list scope: [:type], top_of_list: 0

  scope :in_menu, -> { published.where.not(menu_link_cs: nil, menu_link_en: nil).ordered }
end
