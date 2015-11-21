# ActiveAdmin.register Article do
#   actions :all, except: [:show]
#
#   # See permitted parameters documentation:
#   # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
#   permit_params :published_at,
#     :title_cs, :subtitle_cs, :slug, :perex_cs, :text_content_cs, :meta_title_cs :meta_description_cs
#     :title_en, :subtitle_en, :perex_en, :text_content_en, :meta_title_en, :meta_description_en,
#     images_attributes: [:id, :title_cs, :copyright_cs, :photo, :_destroy, :position]
#
#   config.sort_order = 'published_at_desc'
#
#   controller do
#     def find_resource
#       scoped_collection.friendly.find(params[:id])
#     end
#   end
#
#   index do
#     id_column
#     column :image do |article|
#       image_tag article.cover.thumb("100x50#").url unless article.cover.nil?
#     end
#     column :title
#     column :subtitle
#     column :published_at
#     actions
#   end
#
#   form :html => { :multipart => true } do |f|
#     f.semantic_errors *f.object.errors.keys
#
#     f.inputs "Česky" do
#
#       f.input :id, as: :hidden
#       f.input :published_at, hint: "Datum zveřejnění článku. Je-li prázdné, článek není vidět."
#       f.input :slug, hint: "Není potřeba zadávat, vyplní se samo dle názvu. Pozor, při změně mohou přestat fungovat již existující odkazy."
#
#     end
#
#     columns do
#
#       column do
#         f.inputs "Česky" do
#           f.input :title_cs
#           f.input :subtitle_cs
#           f.input :perex_cs
#           f.input :text_content_cs
#         end
#       end
#
#       column do
#         f.inputs "Anglicky" do
#           f.input :title_en
#           f.input :subtitle_en
#           f.input :perex_en
#           f.input :text_content_en
#         end
#
#       end
#     end
#
#     columns do
#       column do
#         f.inputs "Meta" do
#           f.input :meta_title_cs
#           f.input :meta_description_cs
#         end
#       end
#       column do
#         f.inputs "Meta" do
#           f.input :meta_title_en
#           f.input :meta_description_en
#         end
#       end
#     end
#
#     f.inputs "Galerie" do
#       f.has_many :images, allow_destroy: true, new_record: true do |i|
#         i.input :photo, :as => :file, :hint => i.object.persisted? ? i.template.image_tag(i.object.thumb("100x100").url) : i.template.content_tag(:span, t('admin.not-uploaded'))
#         i.input :title_cs
#         # i.input :copyright_cs
#         i.input :position
#       end
#     end
#
#     f.actions
#
#   end
#
# end
