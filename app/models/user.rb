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
  has_many :project, :dependent => :nullify
  has_many :bids
  has_many :credit_adjustments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :token_authenticatable, :confirmable, :lockable, :timeoutable 

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  def to_s
    return self.profile ? self.profile.name : self.email 
  end

  acts_as_messageable
  def mailboxer_name
    return self.profile ? self.profile.name : self.email 
  end
  def mailboxer_email(object)
    if true # TODO preference check
      return :email
    else
      return nil
	  end
  end

  def unread_message_count
    notifs = Notification.recipient(self).unread.count
  end
end
