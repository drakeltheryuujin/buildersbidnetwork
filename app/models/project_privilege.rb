# == Schema Information
#
# Table name: project_privileges
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class ProjectPrivilege < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  attr_accessor :message_body

  validates :user, :project, :presence => true

  after_create :send_invite

  private

  def send_invite
    sender = self.project.user
    sender_name = sender.name
    subject = "Invitation to bid from #{sender_name}"
    body = self.message_body || "You've been invited to bid on a project."
    sender.send_message_with_object_and_type([self.user], body, subject, project, :project_invite)
  end
end
