module Payment
  extend ActiveSupport::Concern

  included do
    belongs_to :order_tx
  
    attr_accessor :card_number, :card_verification

    validates :first_name, :last_name, :card_type, :card_expires_on, :card_billing_zip, :amount,
      :presence => true
    validates_format_of :card_billing_zip,
                        :with => %r{\d{5}(-\d{4})?},
                        :message => "should be 12345 or 12345-1234"
    validate :validate_card, :on => :create
    
    after_validation :set_card_display_number, :on => :create
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

  def set_card_display_number
    self.card_display_number = credit_card.display_number
  end
end
