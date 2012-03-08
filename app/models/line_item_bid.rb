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

class LineItemBid < ActiveRecord::Base
  belongs_to :bid
  belongs_to :line_item

  validates_numericality_of :unit_cost, :greater_than => 0, :allow_nil => true, :if => :not_deleted?
  validates_numericality_of :cost, :greater_than => 0, :if => :not_deleted?

  default_scope where(:deleted_at => nil)
  def self.deleted
    self.unscoped.where('deleted_at IS NOT NULL')
  end
  def not_deleted?
    :deleted_at.blank?
  end
end
