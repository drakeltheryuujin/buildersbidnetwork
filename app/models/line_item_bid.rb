# == Schema Information
#
# Table name: line_item_bids
#
#  id           :integer(4)      not null, primary key
#  unit_cost     :decimal(8, 2)
#  cost         :decimal(8, 2)
#  bid_id       :integer(4)
#  line_item_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class LineItemBid < ActiveRecord::Base
  belongs_to :bid
  belongs_to :line_item
end
