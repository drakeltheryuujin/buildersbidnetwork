# == Schema Information
#
# Table name: profiles
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  latitude    :float
#  longitude   :float
#  type        :string(255)
#  location_id :integer         not null
#  established :string(255)
#  description :text
#  website     :string(255)
#  asset_file_name    :string(255)
#  asset_content_type :string(255)
#  asset_file_size    :integer
#  asset_updated_at   :datetime

class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  
  has_many :profile_phones
  has_many :phones, :through => :profile_phones
  has_many :profile_documents
  
  has_and_belongs_to_many :project_types

  has_attached_file :asset, {
    :styles => { :square_thumb  => "94x94#", :thumb => "100x100", :large => "600x400" }
  }.merge(PAPERCLIP_STORAGE_OPTIONS)
  
  geocoded_by :location_address
  after_validation :geocode
  
  validates :name, :presence => true

  validates_associated :location
  validates_associated :phones
  
#validates_url_format_of :website, :allow_nil => true
  
  accepts_nested_attributes_for :location, :allow_destroy => :true
  
  accepts_nested_attributes_for :phones, :allow_destroy => :true
  accepts_nested_attributes_for :profile_phones, :allow_destroy => :true

  accepts_nested_attributes_for :project_types, :allow_destroy => :true

  scope :hidden, where(:hidden => true)
  scope :visible, where(:hidden => false)

  scope :distinct_visible, select('DISTINCT profiles.*').visible

  def location_address
    location.address
  end

  def may_modify?(user)
    self.user == user || user.try(:admin?)
  end

  def cover_photo_square_thumb_url(default = '/images/company_square.png')
    (self.asset.present?) ? self.asset(:square_thumb) : default
  end

  def specialty?(project_type)
    self.project_types.include?(project_type)
  end


  # Overriden by subclasses
  def developer_profile?
    return false
  end
  def contractor_profile?
    return false
  end

end
