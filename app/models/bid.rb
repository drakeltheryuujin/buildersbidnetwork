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

  validates :user, :presence => true
  validates :project, :presence => true
  validate :sufficient_credits

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  private

  def sufficient_credits
    self.errors[:base] << "You need #{self.project.credit_value} credits to place this bid, but you only have #{self.user.credits}." unless self.user.credits >= self.project.credit_value
  end
end
