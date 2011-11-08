class CreateProjectDocuments < ActiveRecord::Migration
  def change
    create_table :project_documents do |t|
      t.string :description
      
      t.string :asset_file_name
	    t.string :asset_content_type
	    t.integer :asset_file_size
	    t.datetime :asset_updated_at
      
      t.references :project

      t.timestamps
    end
    add_index :project_documents, :project_id
  end
end
