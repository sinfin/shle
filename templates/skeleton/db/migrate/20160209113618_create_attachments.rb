class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :caption_cs
      t.string :caption_en
      t.string :attachment_uid
      t.string :attachment_name

      t.string :type

      t.string :attachmentable_type
      t.integer :attachmentable_id

      t.integer :position

      t.text :thumbnail_sizes, default: "--- {}\n"

      t.timestamps null: false
    end

    add_index :attachments, :attachmentable_id
    add_index :attachments, :attachmentable_type
    add_index :attachments, :type
  end
end
