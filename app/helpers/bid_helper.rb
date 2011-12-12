module BidHelper
  def may_admin_bid?(bid = @bid, user = current_user)
    bid.user == user || user.try(:admin?)
  end
end
