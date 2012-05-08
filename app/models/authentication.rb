class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, :presence => true

  attr_accessible :provider, :uid, :token, :secret, :avatar_url, :name, :profile_url

  scope :linkedin, where(:provider => :linkedin)

  def linkedin_client
    client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
    client.authorize_from_access(self.token, self.secret)
    client
  end

  def attach_user(user)
    user.transaction do
      ProjectPrivilege.where(:authentication => self).each do |p|
        p.update_attributes(:user => user, :authentication => nil)
      end
      user.authentications << auth
    end
  end

  def update_metadata(li_client = self.linkedin_client)
    li_profile = li_client.profile(:id => self.uid, :fields => [:formatted_name, :picture_url, :public_profile_url])
    self.update_attributes(
        :avatar_url =>  (li_profile[:picture_url].blank?        ? self.avatar_url  : li_profile[:picture_url]),
        :name =>        (li_profile[:formatted_name].blank?     ? self.name        : li_profile[:formatted_name]),
        :profile_url => (li_profile[:public_profile_url].blank? ? self.profile_url : li_profile[:public_profile_url])) 
  end
end
