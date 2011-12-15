module BidHelper
  def may_admin_bid?(bid = @bid, user = current_user)
    bid.may_modify? user
  end
end
