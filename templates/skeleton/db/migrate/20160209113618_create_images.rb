class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :caption
      t.string :photo_uid
      t.integer :imageable_id
      t.string :imageable_type

      t.timestamps null: false
    end

    add_index :images, :imageable_id
    add_index :images, :imageable_type
  end
end
