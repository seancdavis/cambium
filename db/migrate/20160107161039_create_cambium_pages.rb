class CreateCambiumPages < ActiveRecord::Migration
  def change
    create_table :cambium_pages do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.text :markdown
      t.text :html
      t.string :template_name
      t.string :ancestry
      t.integer :position, :default => 0
      t.json :template_data, :default => {}
      t.datetime :active_at
      t.datetime :inactive_at

      t.timestamps null: false
    end
  end
end
