class ChangeOrderTxRelations < ActiveRecord::Migration
  def up
    add_column :order_txes, :user_id, :integer
    OrderTx.reset_column_information
    PaymentCredit.all.each do |pc|
      ot = OrderTx.where(:payment_credit_id => pc.id, :success => true).first
      if ot.present?
        pc.update_attribute(:order_tx_id, ot.id)
        ot.update_attribute(:user_id, pc.user.id)
      end
    end
    remove_column :order_txes, :payment_credit_id
  end

  def down
    add_column :order_txes, :payment_credit_id, :integer
    OrderTx.reset_column_information
    PaymentCredit.all.each do |pc|
      pc.order_tx.update_attribute(:payment_credit_id, pc.id)
    end
    remove_column :order_txes, :user_id
  end
end
