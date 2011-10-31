require 'test_helper'

class LineItemBidTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
# == Schema Information
#
# Table name: line_item_bids
#
#  id           :integer(4)      not null, primary key
#  unitCost     :decimal(8, 2)
#  cost         :decimal(8, 2)
#  bid_id       :integer(4)
#  line_item_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

