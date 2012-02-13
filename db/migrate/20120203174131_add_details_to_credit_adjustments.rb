class AddDetailsToCreditAdjustments < ActiveRecord::Migration
  def change
    add_column :credit_adjustments, :amount, :decimal, :precision => 8, :scale => 2
    add_column :credit_adjustments, :card_display_number, :string
    PaymentCredit.reset_column_information
    PaymentCredit.all.each do |pc|
      pc.update_attributes({:amount => (pc.order_tx.present? ? pc.order_tx.amount.to_i/100 : 0.00), :card_display_number => "xxxx-xxxx-xxxx-xxxx"})
    end
  end
end
