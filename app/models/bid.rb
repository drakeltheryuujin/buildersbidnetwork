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

  STATES = [ :draft, :published, :cancelled, :awarded, :accepted, :held ].collect do |n| n.to_s end
  validates_inclusion_of :state, :in => STATES

  validate :sufficient_credits?, :if => :changed_to_published?

  scope :draft, where(:state => :draft)
  scope :published, where(:state => :published)

# AASM
  aasm_column :state

  aasm_initial_state :draft

  aasm_state :draft
  aasm_state :published, :enter => :charge_credits_and_notify_creator, :exit => :refund_credits
  aasm_state :cancelled
  aasm_state :awarded, :enter => :pending_award_project
  aasm_state :accepted, :enter => :award_project
  aasm_state :held

  aasm_event :publish do
    transitions :to => :published, :from => [:draft, :held, :cancelled]
  end
  aasm_event :cancel do
    transitions :to => :cancelled, :from => [:draft, :published]
  end
  aasm_event :award do
    transitions :to => :awarded, :from => :published
  end
  aasm_event :accept do
    transitions :to => :accepted, :from => :awarded
  end
  aasm_event :hold do
    transitions :to => :held, :from => :published
  end
# /AASM

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  def award_message
    Message.where(:notification_type => :project_award_message).where(:notified_object_type => 'Bid').where(:notified_object_id => self.id).first
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

  def charge_credits_and_notify_creator
    self.credit_adjustments.build(:bid => self, :adjustment_type => :bid_purchase_debit, :user => self.user, :value => (-(self.project.credit_value))) unless self.state_was == :published.to_s
    subject = "Bid from #{self.user.profile.name}"
    body = "#{self.user.profile.name} has entered a bid on your project #{self.project.name}"
    self.user.send_message_with_object_and_type([self.project.user], body, subject, self, :bid_placed_message)
  end

  def award_pending_project
    self.project.update_attribute(:state, :award_pending)
  end

  def award_project
    self.project.update_attribute(:state, :awarded)
  end
end
