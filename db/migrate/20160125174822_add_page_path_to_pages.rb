class AddPagePathToPages < ActiveRecord::Migration
  def change
    add_column :cambium_pages, :page_path, :string
  end
end
