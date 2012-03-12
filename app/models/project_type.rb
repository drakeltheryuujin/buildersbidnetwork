# == Schema Information
#
# Table name: project_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class ProjectType < ActiveRecord::Base
  has_and_belongs_to_many :profiles
end
