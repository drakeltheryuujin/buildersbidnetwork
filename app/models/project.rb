# == Schema Information
#
# Table name: projects
#
#  id              :integer         not null, primary key
#  name            :string(255)     not null
#  user_id         :integer         not null
#  created_at      :datetime
#  updated_at      :datetime
#  bidding_end     :datetime        not null
#  pre_bid_meeting :datetime
#  project_start   :date            not null
#  project_end     :date            not null
#  description     :text            not null
#  notes           :text
#  location_id     :integer         not null
#  project_type_id :integer         not null
#  latitude        :float
#  longitude       :float
#

class Project < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :location
  belongs_to :project_type
  belongs_to :cover_photo, :class_name => 'ProjectDocument'
  
  has_many :line_items
  has_many :bids
  has_many :project_documents
  
  geocoded_by :location_address
  after_validation :geocode
  
  accepts_nested_attributes_for :location, :allow_destroy => :true

  accepts_nested_attributes_for :line_items, :allow_destroy => :true


  validates :name,
    :presence => true
  validates :description,
    :presence => true,
    :unless => :draft?
  validates :bidding_end,
    :presence => true, 
    :date => {:after => Proc.new {Time.now}},
    :unless => :draft?
  validates :project_start,
    :presence => true, 
    :date => {:after => :bidding_end},
    :unless => :draft?
  validates :project_end,
    :presence => true, 
    :date => {:after => :project_start},
    :unless => :draft?
  validates :estimated_budget,
    :presence => true,
    :unless => :draft?
  validates :terms_of_use, 
    :acceptance => true,
    :unless => :draft?
  validates_numericality_of :estimated_budget, :less_than => 1000000000, :unless => :draft?
  validate :validate_estimated_budget_credit_value_in_sync

  validates_associated :location, :project_type 

# AASM
  STATES = [ :draft, :published, :cancelled, :award_pending, :awarded ].collect do |n| n.to_s end
  validates_inclusion_of :state, :in => STATES

  aasm_column :state

  aasm_initial_state :draft

  aasm_state :draft
  aasm_state :published
  aasm_state :cancelled
  aasm_state :award_pending
  aasm_state :awarded

  aasm_event :publish do
    transitions :to => :published, :from => [:draft, :published]
  end
  aasm_event :cancel do
    transitions :to => :cancelled, :from => :published
  end
  aasm_event :award do
    transitions :to => :award_pending, :from => :published
  end
  aasm_event :complete_award do
    transitions :to => :awarded, :from => :award_pending
  end
# /AASM
  
  scope :draft, where(:state => :draft)
  scope :published, where(:state => :published)

  def location_address
    location.address
  end

  def median_bid
    self.bids.published.average 'total'
  end

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  def my_bid(user)
    self.bids.where(:user_id => user).first
  end
  def has_bid?(user)
    my_bid(user).present?
  end

  def winning_bid
    self.bids.accepted.last
  end
  def award_pending_bid
    self.bids.awarded.last
  end

  def bidding_period?
    return Time.now <= self.bidding_end
  end

  def award_period?
    return Time.now >= self.bidding_end
  end

  def hold_bids_and_notify_bidders(body)
    subject = "Project #{self.name} has changed"
    self.bids.published.each do |bid|
      bid.hold!
      self.user.send_message_with_object_and_type([bid.user], body, subject, bid, :project_change_message)
    end
  end

  private

  def validate_estimated_budget_credit_value_in_sync
    if (estimated_budget > 50000 && credit_value < 2) ||
       (estimated_budget > 100000 && credit_value < 3) ||
       (estimated_budget > 250000 && credit_value < 4) ||
       (estimated_budget > 500000 && credit_value < 5) ||
       (credit_value.blank?)
      errors[:base] << "Invalid credit value."
    end
  end
end
