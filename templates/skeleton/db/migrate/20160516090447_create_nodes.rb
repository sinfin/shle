class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :title_cs
      t.string :title_en
      t.string :slug_cs
      t.string :slug_en
      t.string :code
      t.string :type
      t.boolean :featured, deafult: false
      t.boolean :content_locked, deafult: false
      t.boolean :published, default: true
      t.string :menu_link_cs
      t.string :menu_link_en
      t.integer :position

      t.timestamps null: false
    end

    add_index :nodes, :type
    add_index :nodes, :slug_cs
    add_index :nodes, :slug_en
    add_index :nodes, :code
  end
end
