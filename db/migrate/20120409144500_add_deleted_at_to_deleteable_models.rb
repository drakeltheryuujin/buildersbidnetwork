class AddDeletedAtToDeleteableModels < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime
    add_column :subscriptions, :deleted_at, :datetime
    add_column :subscription_adjustments, :deleted_at, :datetime
    add_column :profiles, :deleted_at, :datetime
    add_column :profile_phones, :deleted_at, :datetime
    add_column :projects, :deleted_at, :datetime
    add_column :bids, :deleted_at, :datetime
    add_column :credit_adjustments, :deleted_at, :datetime
    add_column :project_privileges, :deleted_at, :datetime
    add_column :line_items, :deleted_at, :datetime
    add_column :line_item_bids, :deleted_at, :datetime
    add_column :project_documents, :deleted_at, :datetime
    add_column :profile_documents, :deleted_at, :datetime

    add_column :receipts, :deleted_at, :datetime
    add_column :conversations, :deleted_at, :datetime
    add_column :notifications, :deleted_at, :datetime
  end
end
