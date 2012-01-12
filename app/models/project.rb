# == Schema Information
#
# Table name: projects
#
#  id              :integer         not null, primary key
#  name            :string(255)     not null
#  user_id         :integer         not null
#  created_at      :datetime
#  updated_at      :datetime
#  bidding_start   :datetime        not null
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
  belongs_to :user
  belongs_to :location
  belongs_to :project_type
  
  has_many :line_items
  has_many :bids
  has_many :project_documents
  
  geocoded_by :location_address
  after_validation :geocode
  
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


  validates :name,
    :presence => true
  validates :description,
    :presence => true
  validates :bidding_start,
    :presence => true
    #:date => {:after => (! :created_at.nil? ? :created_at : Proc.new { Time.now })}
  validates :bidding_end,
    :presence => true, 
    :date => {:after => Proc.new { Time.now }}
  validates :project_start,
    :presence => true, 
    :date => {:after => Proc.new { Time.now }},
    :on => :create
  validates :project_end,
    :presence => true, 
    :date => {:after => Proc.new { Time.now }},
    :on => :create
  validates :estimated_budget,
    :presence => true
  validates :terms_of_use, 
    :acceptance => true
  validates_numericality_of :estimated_budget, :less_than => 1000000000
  # TODO validate credit_value and estimated_budget are in sync

  validates_associated :location
  validates_associated :project_type

  # TODO Use AASM like with Bid
  STATES = [ :draft, :published, :cancelled, :awarded ]
  validates_inclusion_of :state, :in => STATES
  
  accepts_nested_attributes_for :location, :allow_destroy => :true

  accepts_nested_attributes_for :line_items, :allow_destroy => :true

  def bidding_period?
    return (self.bidding_start <= Time.now) && (Time.now <= self.bidding_end)
  end

  def award_period?
    return Time.now >= self.bidding_end
  end

  def hold_bids_and_notify_bidders
    subject = "[YPN] Project #{self.name} has changed"
    body = "Project #{self.name} has changed.  Your bid has been placed on hold and your credits have been refunded. Please visit the site to update your bid."
    self.bids.published.each do |bid|
      bid.hold!
      self.user.send_message([bid.user], body, subject)
    end
  end
end
