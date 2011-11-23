# == Schema Information
#
# Table name: phones
#
#  id            :integer         not null, primary key
#  number        :string(255)
#  phone_type_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Phone < ActiveRecord::Base
  belongs_to :phone_type
  
  has_many :profile_phones
  has_many :phones, :through => :profile_phones
end
