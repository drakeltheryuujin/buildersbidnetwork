require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "credit value validated against estimated budget" do
    p = Project.new(
      :name => 'test project', 
      :project_type_id => 1,
      :user => users(:one),
      :bidding_end => Time.now + 2.weeks,
      :project_start => Date.today + 3.weeks,
      :project_end => Date.today + 4.weeks,
      :description => "testtest",
      :state => :published.to_s,
      :credit_value => 1,
      :estimated_budget => nil,
      :location_attributes => {:address1 => '97 Bond St', :city => 'Brooklyn', :state => 'NY', :post_code => '11217'},
      :line_items_attributes => [{:content => "content", :units => 1}])
    p.save
    y p.errors
    assert false
  end
end
