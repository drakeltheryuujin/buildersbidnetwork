class GrantedSubscription < SubscriptionAdjustment
  belongs_to :granted_by, :class_name => "User"
end

