class CreateCreditAdjustments < ActiveRecord::Migration
  def change
    create_table :credit_adjustments do |t|
      t.integer :value
      t.string :type, :null => false

      t.references :user, :null => false

      # payment_credit
      t.references :order_tx
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on

      # bid_purchase_debit
      t.references :bid

      # project_purchase_debit
      t.references :project

      t.timestamps
    end
    add_index :credit_adjustments, :user_id
    add_index :credit_adjustments, :bid_id
    add_index :credit_adjustments, :project_id
  end
end
