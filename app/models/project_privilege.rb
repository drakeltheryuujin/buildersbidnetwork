class ProjectPrivilege < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  attr_accessor :message_body, :skip_invite

  validates :user, :project, :presence => true

  after_create :send_invite

  private

  def send_invite
    unless skip_invite
      sender = self.project.user
      sender_name = sender.name
      subject = "Invitation to bid from #{sender_name}"
      body = self.message_body || "You've been invited to bid on a project."
      sender.send_message_with_object_and_type([self.user], body, subject, project, :project_invite)
    end
  end
end
