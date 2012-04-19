class ChangeBidTotalPrecision < ActiveRecord::Migration
  def up
    change_column :bids, :total, :decimal, { :scale => 2, :precision => 10 }
    change_column :line_item_bids, :unit_cost, :decimal, { :scale => 2, :precision => 10 }
    change_column :line_item_bids, :cost, :decimal, { :scale => 2, :precision => 10 }
  end

  def down
    change_column :bids, :total, :decimal, { :scale => 2, :precision => 8 }
    change_column :line_item_bids, :unit_cost, :decimal, { :scale => 2, :precision => 8 }
    change_column :line_item_bids, :cost, :decimal, { :scale => 2, :precision => 8 }
  end
end
