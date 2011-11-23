# == Schema Information
#
# Table name: phones
#
#  id            :integer         not null, primary key
#  number        :string(255)
#  phone_type_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class PhoneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
