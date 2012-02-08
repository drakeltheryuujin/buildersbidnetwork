require File.join(Rails.root, 'lib', 'payment.rb')
class RecurringPayment < SubscriptionAdjustment
  include Payment

  def purchase!(parent)
    return false unless self.valid? && parent.valid?
    response = GATEWAY.recurring(price_in_cents, credit_card, purchase_options)
    begin
      ot = OrderTx.new(:user_id => parent.user_id, :action => "recurring", :amount => price_in_cents, :response => response)
      if response.success?
        self.order_tx = ot
        parent.subscription_id = response.authorization
        return parent.save!
      else
        errors[:base] << response.message 
        ot.save! 
        return false
      end
    rescue
      # void the purchase if we aren't able to save details
      GATEWAY.cancel_recurring(response.authorization)
      raise
    end
  end

  private

  def purchase_options
    { :ip => ip_address,
      :billing_address => {
        :first_name => first_name,
        :last_name => last_name,
	      :zip => card_billing_zip
      },
      :interval => { 
        :unit => :months, 
        :length => 12 
      },
      :duration => {
        :start_date => Date.today,
        :occurrences => 9999
      }
    }
  end
end
