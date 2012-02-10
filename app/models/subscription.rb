##
##
# Represents the current state of the User's subscription.  The subscription_adjustments
# provide an audit trail describing how the Subscription arrived at it's current state.
##
##
class Subscription < ActiveRecord::Base
  belongs_to :user

  has_many :subscription_adjustments

  accepts_nested_attributes_for :subscription_adjustments

  def cancel!
    unless self.upstream_authorization.present?
      errors[:base] << "No current subscription to cancel."
      return false
    end
    subscription_payment = self.subscription_adjustments.where(:type => SubscriptionPayment.to_s, :upstream_authorization => self.upstream_authorization).first
    unless subscription_payment.present?
      errors[:base] << "Subscription payment not found."
      return false
    end

    return subscription_payment.cancel!
  end

  def current?
    return self.valid_until.nil? || self.valid_until >= Time.now
  end

  def update_valid_until(adjustment)
    self.update_attribute(:valid_until, adjustment.end_at)
  end
end
