require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end
# == Schema Information
#
# Table name: projects
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)     not null
#  user_id         :integer(4)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  bidding_start   :datetime        not null
#  bidding_end     :datetime        not null
#  pre_bid_meeting :datetime
#  project_start   :date            not null
#  project_end     :date            not null
#  description     :text            default(""), not null
#  notes           :text
#  location_id     :integer(4)      not null
#  project_type_id :integer(4)      not null
#

