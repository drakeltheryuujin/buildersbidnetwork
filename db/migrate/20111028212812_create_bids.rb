class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.decimal :total, :precision => 8, :scale => 2
      t.references :user
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :bids
  end
end
