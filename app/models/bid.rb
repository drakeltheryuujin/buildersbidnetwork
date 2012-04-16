# == Schema Information
#
# Table name: bids
#
#  id         :integer         not null, primary key
#  total      :decimal(8, 2)
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)     default("draft")
#

class Bid < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :project

  has_many :line_item_bids, :dependent => :destroy
  has_many :credit_adjustments, :dependent => :destroy
  
  accepts_nested_attributes_for :line_item_bids, :allow_destroy => :true


  validates :user, :presence => true
  validates :project, :presence => true

  STATES = [ :draft, :published, :cancelled, :awarded, :accepted, :held ].collect do |n| n.to_s end
  validates_inclusion_of :state, :in => STATES

  validate :sufficient_credits?
  validate :total_matches_line_item_bids?

  validates_associated :line_item_bids
  validates_numericality_of :total, :greater_than => 0, :less_than => 10**6

  after_save :charge_credits_and_notify_creator if :changed_to_published?

  aasm :column => :state do
    state :draft, :initial => true
    state :published
    state :cancelled, :enter => :refund_credits
    state :awarded, :enter => :award_project
    state :accepted, :enter => :award_complete
    state :held, :enter => :refund_credits

    event :publish do
      transitions :to => :published, :from => [:draft, :held, :cancelled]
    end
    event :cancel do
      transitions :to => :cancelled, :from => [:draft, :published]
    end
    event :award do
      transitions :to => :awarded, :from => :published
    end
    event :accept do
      transitions :to => :accepted, :from => :awarded
    end
    event :hold do
      transitions :to => :held, :from => :published
    end
  end

  scope :draft, where(:state => :draft)
  scope :published, where(:state => :published)
  scope :awarded, where(:state => :awarded)
  scope :accepted, where(:state => :accepted)
  scope :visible, where(:state => [:accepted, :awarded, :published], :deleted_at => nil)

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  def award_message
    Message.where(:notification_type => :project_award_message, :notified_object_type => 'Bid', :notified_object_id => self.id).first
  end

  def changed_to_published?
    self.state_changed? && self.published?
  end

  private

  def total_matches_line_item_bids?
    unless (self.line_item_bids.collect { |lib| (lib.cost.blank? ? 0 : lib.cost) }.sum) == self.total
      self.errors[:base] << "Total is not in sync with line item costs."
      return false
    else
      return true
    end
  end

  def sufficient_credits?
    unless ((self.user.credits.blank? ? 0 : self.user.credits) >= self.project.credit_value)
      self.errors[:base] << "You need #{self.project.credit_value} credits to place this bid, but you only have #{self.user.credits}." 
      return false
    else
      return true
    end
  end

  def refund_credits 
    self.credit_adjustments.build(:bid => self, :adjustment_type => :bid_purchase_refund_credit, :user => self.user, :value => self.project.credit_value)
  end

  def charge_credits_and_notify_creator
    if sufficient_credits?
      ca = self.credit_adjustments.build(:bid => self, :adjustment_type => :bid_purchase_debit, :user => self.user, :value => (-(self.project.credit_value)))
      subject = "Bid from #{self.user.profile.name}"
      body = "#{self.user.profile.name} has entered a bid on your project #{self.project.name}"
      self.user.send_message_with_object_and_type([self.project.user], body, subject, self, :bid_placed_message)
      ca.save
    else
      return false
    end
  end

  def award_project
    self.project.award!
  end

  def award_complete
    self.project.complete_award!
  end
end
