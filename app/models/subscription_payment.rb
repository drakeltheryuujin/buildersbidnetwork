require File.join(Rails.root, 'lib', 'payment.rb')
class SubscriptionPayment < SubscriptionAdjustment
  include Payment

  def purchase_old!(parent)
    return false unless self.valid? && parent.valid?
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    begin
      ot = OrderTx.new(:user_id => parent.user_id, :action => "purchase", :amount => price_in_cents, :response => response)
      if response.success?
        self.order_tx = ot
        return parent.save!
      else
        errors[:base] << response.message 
        ot.save! 
        return false
      end
    rescue
      # void the purchase if we aren't able to save details
      GATEWAY.void(response.authorization)
      raise
    end
  end

  def purchase!(parent)
    return false unless self.valid? && parent.valid?
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    begin
      ot = OrderTx.new(:user_id => parent.user_id, :action => "purchase", :amount => price_in_cents, :response => response)
      unless response.success?
        errors[:base] << response.message 
      else
        recurring_response = GATEWAY.recurring(price_in_cents, credit_card, purchase_options)
        unless recurring_response.success?
          errors[:base] << recurring_response.message 
        else
          self.order_tx = ot
          parent.subscription_id = recurring_response.authorization
          return parent.save!
        end
      end
      ot.save! 
      return false
    rescue # void the purchase if we aren't able to save details
      GATEWAY.void(response.authorization)
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
        :start_date => Date.today + 1.year,
        :occurrences => 9999
      }
    }
  end

end

