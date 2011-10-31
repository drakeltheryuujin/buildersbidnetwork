# == Schema Information
#
# Table name: bids
#
#  id         :integer(4)      not null, primary key
#  total      :decimal(8, 2)
#  user_id    :integer(4)
#  project_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Bid < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  
  has_many :line_item_bids
  
  accepts_nested_attributes_for :line_item_bids, :allow_destroy => :true
end
