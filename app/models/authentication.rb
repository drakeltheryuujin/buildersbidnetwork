class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :provider, :uid, :presence => true

  attr_accessible :provider, :uid, :token, :secret, :avatar_url

  scope :linkedin, where(:provider => :linkedin)

  def linked_in_client
    client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
    client.authorize_from_access(self.token, self.secret)
    client
  end
end
