class CreatePages < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS hstore'
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.text :description
      t.string :template
      t.string :slug
      t.string :ancestry
      t.integer :position
      t.boolean :in_nav
      t.datetime :active_at, default: nil
      t.datetime :inactive_at, default: nil
      t.hstore :template_data
      t.timestamps
    end
    add_index  :pages, :template_data, using: 'gin'
  end
  def down
    remove_table :pages
    execute 'DROP EXTENSION hstore'
  end
end
