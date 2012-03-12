class CreateProfileDocuments < ActiveRecord::Migration
  def change
    create_table :profile_documents do |t|
      t.string :description
      
      t.string :asset_file_name
      t.string :asset_content_type
      t.integer :asset_file_size
      t.datetime :asset_updated_at
      
      t.references :profile
      
      t.timestamps
    end
    add_index :profile_documents, :profile_id
  end
end