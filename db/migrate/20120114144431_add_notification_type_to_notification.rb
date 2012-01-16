class AddNotificationTypeToNotification < ActiveRecord::Migration
  def self.up
    change_table :notifications do |t|
      t.string :notification_type
    end
  end

  def self.down
    change_table :notifications do |t|
      t.remove :notification_type
    end
  end
end
