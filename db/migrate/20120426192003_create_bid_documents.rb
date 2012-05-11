class CreateBidDocuments < ActiveRecord::Migration
  def change
    create_table :bid_documents do |t|
      t.string :description
      
      t.string :asset_file_name
      t.string :asset_content_type
      t.integer :asset_file_size
      t.datetime :asset_updated_at
      
      t.datetime :deleted_at

      t.references :bid

      t.timestamps
    end
    add_index :bid_documents, :bid_id
  end
end
