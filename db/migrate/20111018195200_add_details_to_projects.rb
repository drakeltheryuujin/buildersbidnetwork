class AddDetailsToProjects < ActiveRecord::Migration
  def self.up
    change_column :projects, :name, :string, :null => false
    change_column :projects, :user_id, :integer, :null => false
    add_column :projects, :bidding_start, :datetime, :null => false
    add_column :projects, :bidding_end, :datetime, :null => false
    add_column :projects, :pre_bid_meeting, :datetime
    add_column :projects, :project_start, :date, :null => false
    add_column :projects, :project_end, :date, :null => false
    add_column :projects, :description, :text, :null => false
    add_column :projects, :notes, :text
    change_table :projects do |t|
      t.references :location, :null => false
      t.references :project_type, :null => false
    end
  end

  def self.down
    remove_column :projects, :description
    remove_column :projects, :notes
    remove_column :projects, :project_end
    remove_column :projects, :project_start
    remove_column :projects, :pre_bid_meeting
    remove_column :projects, :bidding_end
    remove_column :projects, :bidding_start
    remove_column :projects, :location_id
    remove_column :projects, :project_type_id
  end
end
