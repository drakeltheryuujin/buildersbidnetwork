require 'test_helper'

class OrderTxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: order_txes
#
#  id                :integer         not null, primary key
#  payment_credit_id :integer
#  action            :string(255)
#  amount            :integer
#  success           :boolean
#  authorization     :string(255)
#  message           :string(255)
#  params            :text
#  created_at        :datetime
#  updated_at        :datetime
#

