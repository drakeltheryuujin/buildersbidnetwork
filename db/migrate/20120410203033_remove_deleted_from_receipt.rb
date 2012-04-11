class RemoveDeletedFromReceipt < ActiveRecord::Migration
  def up
    remove_column :receipts, :deleted
  end

  def down
    add_column :receipts, :deleted, :boolean
  end
end
