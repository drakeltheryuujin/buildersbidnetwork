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
end
