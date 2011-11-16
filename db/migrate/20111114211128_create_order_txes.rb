class CreateOrderTxes < ActiveRecord::Migration
  def change
    create_table :order_txes do |t|
      t.references :payment_credit

      t.string :action
      t.integer :amount
      t.boolean :success
      t.string :authorization
      t.string :message
      t.text :params

      t.timestamps
    end
  end
end
