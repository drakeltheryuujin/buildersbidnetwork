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
class PaymentCredit < CreditAdjustmentCredit
  has_many :order_txes
  
  attr_accessor :card_number, :card_verification, :amount
  
  validates :first_name, :last_name, :card_type, :card_expires_on, :card_billing_zip, 
    :presence => true
  validates_format_of :card_billing_zip,
	                    :with => %r{\d{5}(-\d{4})?},
	                    :message => "should be 12345 or 12345-1234"
	validate :validate_card, :on => :create
  validate :validate_package, :on => :create
  
  def purchase!
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    order_txes.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    raise "Error: " + response.message unless response.success?
    user.update_attribute(:credits, user.credit_adjustments.sum(:value)) if response.success?
  end
  
  def price_in_cents
    (amount.to_f*100).round
  end

  private
  
  def purchase_options
    { :ip => ip_address,
      :billing_address => {
	      :zip => card_billing_zip
      }
    }
  end
  
  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors[:base] << message
      end
    end
  end

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
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
end
