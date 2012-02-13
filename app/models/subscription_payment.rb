##
##
# This class initiates a recurring payment through Authorize.net's ARB
# API.  It represents the start of an ongoing recurring payment schedule, as well as
# the reciept of the first payment.
#
# For the time being, subscriptions are created with open ended validty, meaning 
# they will be considered valid until manually given an end date.  In the future,
# when recurring payments are actively verified, this Adjustement should only extend
# Subscription validity for the first billing interval.
##
##
require File.join(Rails.root, 'lib', 'payment.rb')
class SubscriptionPayment < SubscriptionAdjustment
  include Payment

  validates :interval, :presence => true

  PACKAGES = {:monthly => 89.95, :yearly => 959.40}
  INTERVALS = PACKAGES.keys.collect do |n| n.to_s end
  validates_inclusion_of :interval, :in => INTERVALS

  validate :validate_package, :on => :create

  ## 
  # Purchase first period's subscription now.  If that's successful, schedule recurring payments
  # starting in one period and continuing indefinitely.  
  ##
  def purchase!(parent)
    return false unless self.valid? && parent.valid?
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    begin
      ot = OrderTx.new(:user_id => parent.user_id, :action => "subscribe", :amount => price_in_cents, :response => response)
      unless response.success?
        errors[:base] << response.message 
      else
        recurring_response = GATEWAY.recurring(price_in_cents, credit_card, recurring_purchase_options)
        unless recurring_response.success?
          GATEWAY.void(response.authorization)
          errors[:base] << recurring_response.message 
        else
          self.order_tx = ot
          self.upstream_authorization = recurring_response.authorization
          self.end_at = nil # Time.now + billing_interval
          parent.upstream_authorization = self.upstream_authorization
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

  def cancel!
    unless self.upstream_authorization.present?
      errors[:base] << "Missing upstream authorization identifier."
      return false
    end
    response = GATEWAY.cancel_recurring(self.upstream_authorization)
    begin
      ot = OrderTx.new(:user_id => self.subscription.user_id, :action => "cancel-subscription", :amount => 0, :response => response)
      unless response.success?
        errors[:base] << response.message 
        ot.save! 
        return false
      else
        self.order_tx = ot
        self.end_at = Time.now
        self.subscription.valid_until = self.end_at
        self.subscription.upstream_authorization = nil
        return self.subscription.save! && self.save!
      end
    rescue # void the purchase if we aren't able to save details
      GATEWAY.void(response.authorization)
      raise
    end
  end

  def yearly?
    self.interval.to_sym == :yearly
  end
  def monthly?
    self.interval.to_sym == :monthly
  end

  def billing_interval
    self.monthly? ? 1.month : 1.year
  end

  private

  def validate_package
    unless amount == PACKAGES[interval.to_sym]
      errors[:base] << "Invalid purchase."
    end
  end

  def recurring_purchase_options
    { :ip => ip_address,
      :billing_address => {
        :first_name => first_name,
        :last_name => last_name,
        :zip => card_billing_zip
      },
      :interval => { 
        :unit => :months, 
        :length => interval_length_months
      },
      :duration => {
        :start_date => duration_start_date,
        :occurrences => 9999
      }
    }
  end

  def interval_length_months
    self.monthly? ? 1 : 12
  end

  def duration_start_date
    (self.start_at + self.billing_interval).to_date
  end
end

