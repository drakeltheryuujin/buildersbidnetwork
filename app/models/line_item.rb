# == Schema Information
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  content    :string(255)
#  units      :integer(4)
#  project_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class LineItem < ActiveRecord::Base
  belongs_to :project
  
  has_many :line_item_bids, :dependent => :destroy
  validates_length_of :content,:maximum =>255
  validates_numericality_of :units, :greater_than => 0, :allow_nil => true
end
