class AddHiddenToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :hidden, :boolean, :default => false
  end
end
