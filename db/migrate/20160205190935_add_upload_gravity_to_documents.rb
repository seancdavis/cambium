class AddUploadGravityToDocuments < ActiveRecord::Migration
  def change
    add_column :cambium_documents, :upload_gravity, :string
  end
end
