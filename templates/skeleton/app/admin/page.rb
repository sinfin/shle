ActiveAdmin.register Page do
  actions :all, except: [:show, :destroy, :create, :new]

  permit_params :title_cs, :title_en, :slug, :published, :position, :featured, :code,
                content_parts_attributes: [:id, :_destroy, :text_cs, :text_en, :position, :variant,
                                           images_attributes: [:id, :_destroy, :attachment, :position]],
                file_attachments_attributes: [:id, :_destroy, :caption_cs, :caption_en, :attachment, :position]

  config.sort_order = 'position_asc'
  config.paginate   = false
  sortable

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    column :id
    column :code
    column :menu_link
    column :title
    actions
    sortable_handle_column
  end

  form html: { multipart: true } do |f|
    f.semantic_errors(*f.object.errors.keys)

    columns do
      column do
        f.inputs 'Česky' do
          f.input :title_cs
          f.input :menu_link_cs, hint: t('admin.hints.menu_link')
          f.input :slug_cs,
                  hint: t('admin.hints.slug'),
                  input_html: { disabled: f.object.content_locked }
        end
      end
      column do
        f.inputs 'English' do
          f.input :title_en
          f.input :menu_link_en, hint: t('admin.hints.menu_link')
          f.input :slug_en,
                  hint: t('admin.hints.slug'),
                  input_html: { disabled: f.object.content_locked }
        end
      end
    end

    f.inputs 'Meta' do
      f.input :published,
              hint: t('admin.hints.published'),
              label: t('admin.labels.published'),
              input_html: { disabled: f.object.content_locked }
      f.input :featured,
              hint: t('admin.hints.featured'),
              label: t('admin.labels.featured'),
              input_html: { disabled: f.object.content_locked }
      f.input :code,
              hint: t('admin.hints.code'),
              input_html: { disabled: f.object.content_locked }
    end

    f.inputs 'Content' do
      f.has_many :content_parts,
                 allow_destroy: !f.object.content_locked,
                 new_record: !f.object.content_locked,
                 sortable: (f.object.content_locked ? false : :position) do |i|
        i.input :variant, as: :select, include_blank: false,
                collection: ContentPart.variants,
                input_html: { class: 'variant-select', disabled: f.object.content_locked }
        i.input :text_cs, hint: admin_markdown_hint
        i.input :text_en, hint: admin_markdown_hint
        unless f.object.content_locked
          i.has_many :images, allow_destroy: true, sortable: :position do |j|
            j.input :attachment, as: :file, hint: admin_image_preview(j)
          end
        end
      end
    end

    f.inputs 'Files' do
      f.has_many :file_attachments, allow_destroy: true, sortable: :position do |i|
        i.input :caption_cs
        i.input :caption_en
        i.input :attachment, as: :file, hint: admin_file_preview(i)
      end
    end

    f.actions
  end
end
