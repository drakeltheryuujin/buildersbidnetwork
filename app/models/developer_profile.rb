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
#

class DeveloperProfile < Profile
  def type_name
    "Developer"
  end
  def developer_profile?
    return true
  end
end
