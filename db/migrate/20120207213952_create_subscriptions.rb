class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :subscription_id
      t.datetime :valid_until
      t.references :user

      t.timestamps
    end
  end
end
