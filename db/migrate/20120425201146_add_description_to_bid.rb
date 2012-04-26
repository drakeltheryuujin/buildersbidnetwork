class AddDescriptionToBid < ActiveRecord::Migration
  def change
    add_column :bids, :description, :text
  end
end
