# == Schema Information
#
# Table name: phone_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PhoneType < ActiveRecord::Base
  def self.find_by_name_or_default(name = nil)
    name = 'office' if name == 'work'
    PhoneType.find(:first, :conditions => [ "lower(name) = ?", name.downcase ]) || PhoneType.find(1)
  end
end
