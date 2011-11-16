class AddCardBillingZipToCreditAdjustments < ActiveRecord::Migration
  def change
    add_column :credit_adjustments, :card_billing_zip, :string
  end
end
