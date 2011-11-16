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
#  id           :integer         not null, primary key
#  unit_cost    :decimal(8, 2)
#  cost         :decimal(8, 2)
#  bid_id       :integer
#  line_item_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

