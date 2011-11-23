class AddLatLongToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :latitude, :float
    add_column :profiles, :longitude, :float
    add_column :profiles, :type, :string
    change_table :profiles do |t|
      t.references :location, :null => false
    end
  end
end
