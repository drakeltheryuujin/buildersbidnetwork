# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  belongs_to :user
end
