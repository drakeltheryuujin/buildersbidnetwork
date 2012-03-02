class AddAssetToProfiles < ActiveRecord::Migration
  def up
    add_column :profiles, :asset_file_name, :string
    add_column :profiles, :asset_content_type, :string
    add_column :profiles, :asset_file_size, :integer
    add_column :profiles, :asset_updated_at, :datetime
  end

  def down
    remove_column :profiles, :asset_file_name
    remove_column :profiles, :asset_content_type
    remove_column :profiles, :asset_file_size
    remove_column :profiles, :asset_updated_at
  end
end
