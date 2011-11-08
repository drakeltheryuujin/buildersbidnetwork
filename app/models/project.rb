# == Schema Information
#
# Table name: projects
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)     not null
#  user_id         :integer(4)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  bidding_start   :datetime        not null
#  bidding_end     :datetime        not null
#  pre_bid_meeting :datetime
#  project_start   :date            not null
#  project_end     :date            not null
#  description     :text            default(""), not null
#  notes           :text
#  location_id     :integer(4)      not null
#  project_type_id :integer(4)      not null
#

class Project < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :project_type
  
  has_many :line_items
  has_many :bids
  has_many :project_documents

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
    :date => {:after => Proc.new { Time.now }}
  validates :project_end,
    :presence => true, 
    :date => {:after => Proc.new { Time.now }}

  validates_associated :location
  validates_associated :project_type
  
  accepts_nested_attributes_for :location, :allow_destroy => :true

  accepts_nested_attributes_for :line_items, :allow_destroy => :true
end
