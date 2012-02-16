class RemoveBiddingStartFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :bidding_start
  end

  def down
    add_column :projects, :bidding_start, :datetime, :null => false
  end
end
