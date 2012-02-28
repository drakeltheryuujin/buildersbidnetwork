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

  has_many :project_privileges
  has_many :privileged_users, :through => :project_privileges, :source => :user
  
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
    :if => :published?
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
  validates_numericality_of :estimated_budget, :greater_than => 0, :less_than => 1000000000, :unless => :draft?
  validate :validate_estimated_budget_credit_value_in_sync, :unless => :draft?

  validates_associated :location, :project_type 

  validate :must_have_line_items, :unless => :draft?

  STATES = [ :draft, :published, :cancelled, :award_pending, :awarded ].collect do |n| n.to_s end
  validates_inclusion_of :state, :in => STATES

  aasm :column => :state do
    state :draft, :initial => true
    state :published
    state :cancelled
    state :award_pending
    state :awarded

    event :publish do
      transitions :to => :published, :from => [:draft, :published]
    end
    event :cancel do
      transitions :to => :cancelled, :from => :published
    end
    event :award do
      transitions :to => :award_pending, :from => :published
    end
    event :complete_award do
      transitions :to => :awarded, :from => :award_pending
    end
  end
  
  scope :draft, where(:state => :draft)
  scope :published, where(:state => :published)

  scope :active, lambda { where("bidding_end >= :now", :now => Time.now) }

  scope :private, where(:private => true)

  scope :accessible_by, lambda { |user|
    joins(:project_privileges).where(:project_privileges => { :user_id => user.id })
  }

  def location_address
    location.address
  end

  def median_bid
    self.bids.published.average 'total'
  end

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  def may_access?(user)
    self.private == false || self.may_modify?(user) || self.has_privilege?(user)
  end

  def may_view_details?(user)
    user.subscription_current? || self.may_modify?(user) || self.has_privilege?(user)
  end

  def has_privilege?(user)
    ProjectPrivilege.where(:project_id => self.id, :user_id => user.id).present?
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
    if (estimated_budget == nil) ||
       (estimated_budget > 50000 && credit_value < 2) ||
       (estimated_budget > 100000 && credit_value < 3) ||
       (estimated_budget > 250000 && credit_value < 4) ||
       (estimated_budget > 500000 && credit_value < 5) ||
       (credit_value.blank?) 
      errors[:base] << "Invalid credit value."
    end
  end

  def must_have_line_items
    if line_items.empty? or line_items.all? {|line_item| line_item.marked_for_destruction? }
      errors[:base] << "Projects must include at least one Line Item."
    end
  end
end
