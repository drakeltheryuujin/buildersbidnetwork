# == Schema Information
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  address1   :string(255)
#  address2   :string(255)
#  city       :string(255)
#  state      :string(255)
#  postCode   :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Location < ActiveRecord::Base
  belongs_to :project
  
  geocoded_by :address
	after_validation :geocode
  
  validates :address1, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  validates :post_code, 
    :presence => true, 
    :format => { :with => %r{\d{5}(-\d{4})?}, :message => "should be 12345 or 12345-1234" }
    
  def address
    #"36 Cooper Sq, 4th Floor, New York, NY 10003"
    address1 + (address2 ? ", " + address2 : "") + ", " + city + ", " + state + " " + post_code
  end

  def to_s
    return address
  end
end
