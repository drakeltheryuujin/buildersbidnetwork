#class AdminUser < User
class AdminUser < ActiveRecord::Base
  self.table_name = :users

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :token_authenticatable, :confirmable, :lockable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :remember_me


  def name
    return self.profile.present? ? self.profile.name : self.email 
  end

  def to_s
    return name
  end
end
