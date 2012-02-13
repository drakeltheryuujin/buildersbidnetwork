class CreateSubscriptionAdjustments < ActiveRecord::Migration
  def change
    create_table :subscription_adjustments do |t|
      t.references :subscription, :null => false
      t.string :type, :null => false

      t.datetime :start_at
      t.datetime :end_at

      # GrantedSubscription
      t.references :granted_by

      # RecurringPayment/SubscriptionPayment
      t.references :order_tx
      t.string :upstream_authorization
      t.decimal :amount, :precision => 8, :scale => 2

      # SubscriptionPayment
      t.string :interval
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.string :card_display_number
      t.string :card_billing_zip
      t.date :card_expires_on


      t.timestamps
    end
  end
end
