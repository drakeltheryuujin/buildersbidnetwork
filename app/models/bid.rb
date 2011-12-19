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
  include AASM

  belongs_to :user
  belongs_to :project

  has_many :line_item_bids
  has_many :credit_adjustments
  
  accepts_nested_attributes_for :line_item_bids, :allow_destroy => :true


  validates :user, :presence => true
  validates :project, :presence => true

  STATES = [ :draft, :published, :cancelled, :awarded, :held ].collect do |n| n.to_s end
  validates_inclusion_of :state, :in => STATES

  validate :sufficient_credits?, :if => :changed_to_published?

  scope :draft, where(:state => :draft)
  scope :published, where(:state => :published)

# AASM
  aasm_column :state

  aasm_initial_state :draft

  aasm_state :draft
  aasm_state :published, :enter => :charge_credits, :exit => :refund_credits
  aasm_state :cancelled
  aasm_state :awarded
  aasm_state :held

  aasm_event :publish do
    transitions :to => :published, :from => [:draft, :hold, :cancelled]
  end
  aasm_event :cancel do
    transitions :to => :cancelled, :from => [:draft, :published]
  end
  aasm_event :award do
    transitions :to => :awarded, :from => :published
  end
  aasm_event :hold do
    transitions :to => :held, :from => :published
  end
# /AASM

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  private

  def changed_to_published?
    self.state_changed? && self.published?
  end

  def sufficient_credits?
    self.errors[:base] << "You need #{self.project.credit_value} credits to place this bid, but you only have #{self.user.credits}." unless ((self.user.credits.blank? ? 0 : self.user.credits) >= self.project.credit_value)
  end

  def refund_credits 
    self.credit_adjustments.build(:bid => self, :adjustment_type => :bid_purchase_refund_credit, :user => self.user, :value => self.project.credit_value)
  end

  def charge_credits
    self.credit_adjustments.build(:bid => self, :adjustment_type => :bid_purchase_debit, :user => self.user, :value => (-self.project.credit_value)) unless self.state_was == :published.to_s
  end
end
