# == Schema Information
#
# Table name: credit_adjustments
#
#  id               :integer         not null, primary key
#  value            :integer
#  type             :string(255)     not null
#  user_id          :integer         not null
#  order_tx_id      :integer
#  ip_address       :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  card_type        :string(255)
#  card_expires_on  :date
#  card_billing_zip :string(255)
#  bid_id           :integer
#  project_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#
require File.join(Rails.root, 'lib', 'payment.rb')
class PaymentCredit < CreditAdjustmentCredit
  include Payment

  validate :validate_package, :on => :create

  def purchase
    return false unless self.valid?
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    ot = OrderTx.new(:user_id => self.user_id, :action => "purchase", :amount => price_in_cents, :response => response)
    if response.success?
      self.order_tx = ot
      return self.save
    else
      errors[:base] << response.message 
      ot.save!
      return false
    end
  end
  
  private
  
  def validate_package
    v = value.to_i
    a = amount.to_i
    if v < 10 && a != (v * CreditsController::PricePerCredit)
      errors[:base] << "Invalid purchase."
    elsif v >= 10
      valid = false
      CreditsController::GroupPackages.each do |package|
        if(v == package[0] && a == package[1]) 
          valid = true 
          break
        end
      end
      unless valid
        errors[:base] << "Invalid package purchase."
      end
    end
  end
end
