# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  credits                :integer
#  admin                  :boolean         default(FALSE)
#  invitation_token       :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invited_project_id     :integer
#

class User < ActiveRecord::Base
  has_one :profile, :dependent => :destroy
  has_one :subscription, :dependent => :destroy
  has_many :project, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_many :credit_adjustments, :dependent => :destroy

  has_many :project_privileges, :dependent => :destroy
  has_many :accessible_projects, :through => :project_privileges, :source => :project, :uniq => true

  belongs_to :invited_project, :class_name => 'Project'
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :token_authenticatable, :confirmable, :lockable, :timeoutable 

  # Setup accessible (or protected) attributes for your model
  attr_accessor :message_body
  attr_accessible :email, :password, :password_confirmation, :remember_me, :message_body

  validate :email_immutable, :on => :update

  scope :privileged_on, lambda { |project|
    joins(:project_privileges).where(:project_privileges => { :project_id => project.id })
  }

  scope :has_logged_in, where("sign_in_count > 0")
  scope :never_logged_in, where("sign_in_count = 0")

  def name
    return self.profile.present? ? self.profile.name : self.email 
  end

  def to_s
    return name
  end

  acts_as_messageable
  def mailboxer_name
    return name
  end
  def mailboxer_email(object)
    if self.deleted_at.blank?
      return email
    else
      return nil
	  end
  end
  def notifications(filter = nil)
    notifs = Notification.recipient(self).order("notifications.created_at DESC")
    if filter.present? && filter.to_sym == :unread
      notifs = notifs.unread
    elsif filter.present? && filter.to_sym == :trash
      notifs = notifs.where('receipts.trashed' => true)
    elsif filter.present? && filter.to_sym == :sent
      notifs = notifs.where('receipts.mailbox_type' => 'sentbox', 'receipts.trashed' => false)
    else
      notifs = notifs.not_trashed.where("\"receipts\".\"mailbox_type\" = 'inbox' OR \"receipts\".\"mailbox_type\" is null")
    end
  end

  def active_for_authentication?
    super && self.deleted_at.blank?
  end

  def unread_message_count
    notifs = Notification.recipient(self).unread.count
  end

  def developer?
    return self.profile.present? ? self.profile.developer_profile? : false
  end
  def contractor?
    return self.profile.present? ? self.profile.contractor_profile? : false
  end

  def subscription_current?
    return (self.subscription.present? ? self.subscription.current? : false)
  end

  def has_private_privileges?
    return self.project_privileges.present?
  end


  # Modified version of send_message from Mailboxer::Modles::Messagable
  def send_message_with_object_and_type(recipients, msg_body, subject, obj = nil, type = nil, sanitize_text = true)
    convo = Conversation.new({:subject => subject})
    message = Message.new({
        :sender => self, 
        :conversation => convo,  
        :body => msg_body, 
        :subject => subject})
    message.notified_object = obj if obj.present?
    message.notification_type = type if type.present?
    message.recipients = recipients.is_a?(Array) ? recipients : [recipients]
    message.recipients = message.recipients.uniq
    return message.deliver(false,sanitize_text)
  end

  def reply_with_object_and_type(conversation, recipients, reply_body, subject = nil, obj = nil, type = nil, sanitize_text = true)
    subject = subject || "RE: #{conversation.subject}"
    response = Message.new({:sender => self, :conversation => conversation, :body => reply_body, :subject => subject})
    response.notified_object = obj if obj.present?
    response.notification_type = type if type.present?
    response.recipients = recipients.is_a?(Array) ? recipients : [recipients]
    response.recipients = response.recipients.uniq
    response.recipients.delete(self)
    return response.deliver true,sanitize_text
  end

  def send_welcome_notification
    notification = Notification.new({:body => "Welcome!", :subject => "Welcome to BBN!", :notification_type => :welcome_notification})
    notification.recipients = [self]
    return notification.deliver false
  end


  private

  def email_immutable
    errors[:base] << "E-mail cannot be changed after registration." if self.email_changed?  && !self.new_record?
  end
end
