class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :upstream_authorization
      t.datetime :valid_until
      t.references :user

      t.timestamps
    end
  end
end
