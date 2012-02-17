# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
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
#

class User < ActiveRecord::Base
  has_one :profile, :dependent => :delete
  has_one :subscription
  has_many :project, :dependent => :nullify
  has_many :bids
  has_many :credit_adjustments

  has_many :project_privileges
  has_many :accessible_projects, :through => :project_privileges, :source => :project

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :token_authenticatable, :confirmable, :lockable, :timeoutable 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  
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
    if true # TODO preference check
      return email
    else
      return nil
	  end
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
end
