##
##
# This class represents a confirmed recurring payment.  It's responsibility is to
# extend the validity of it's parent subscription for another billing interval.
#
# At present, this class is not used, but is in place for use by future Silent Post
# or homemade recurring payment systems.
##
##
class RecurringPayment < SubscriptionAdjustment
  belongs_to :order_tx

  validates :subscription_id, :presence => true
end
