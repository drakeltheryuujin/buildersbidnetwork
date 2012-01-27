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

  def winning_bid
    self.bids.where(:state => :accepted.to_s)
  end
  def award_pending_bid
    self.bids.where(:state => :awarded.to_s)
  end


  validates :name,
    :presence => true
  validates :description,
    :presence => true,
    :unless => :draft?
  validates :bidding_start,
    :presence => true,
    #:date => {:after => (! :created_at.nil? ? :created_at : Proc.new { Time.now })}
    :date => {:after => Proc.new {Time.now}},
    :unless => :draft?
  validates :bidding_end,
    :presence => true, 
    :date => {:after => :bidding_start},
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
  # TODO validate credit_value and estimated_budget are in sync

  validates_associated :location, :project_type 

  # TODO Use AASM like with Bid
  STATES = [ :draft, :published, :cancelled, :award_pending, :awarded ]
  validates_inclusion_of :state, :in => STATES
  
  accepts_nested_attributes_for :location, :allow_destroy => :true

  accepts_nested_attributes_for :line_items, :allow_destroy => :true

  scope :published, where(:state => :published)

  def bidding_period?
    return (self.bidding_start <= Time.now) && (Time.now <= self.bidding_end)
  end

  def award_period?
    return Time.now >= self.bidding_end
  end

  def draft?
    self.state.to_s == :draft.to_s
  end

  def hold_bids_and_notify_bidders(body)
    subject = "Project #{self.name} has changed"
    self.bids.published.each do |bid|
      bid.hold!
      self.user.send_message_with_object_and_type([bid.user], body, subject, bid, :project_change_message)
    end
  end
end
