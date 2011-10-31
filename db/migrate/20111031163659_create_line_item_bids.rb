class CreateLineItemBids < ActiveRecord::Migration
  def self.up
    create_table :line_item_bids do |t|
      t.decimal :unit_cost, :precision => 8, :scale => 2
      t.decimal :cost, :precision => 8, :scale => 2
      t.references :bid
      t.references :line_item

      t.timestamps
    end
  end

  def self.down
    drop_table :line_item_bids
  end
end
