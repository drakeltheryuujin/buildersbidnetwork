# == Schema Information
#
# Table name: profile_phones
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  phone_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProfilePhone < ActiveRecord::Base
  belongs_to :profile
  belongs_to :phone
end
