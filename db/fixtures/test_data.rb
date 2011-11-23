class << ActiveRecord::Base
	def create_or_update_by_name(name, options = {})
    record = find_by_name(name) || new
    record.name = name
    record.attributes = options
    record.save!
    
    record
  end
end


email = "user@developera.com"
u_dA = User.find_or_create_by_email(email, :password => email)
location_dA = Location.find_or_create_by_address1("200 Varick St", 
  :address2 => "10th Floor", :city => "New York", :state => "NY", :post_code => "10014")
profile_dA = DeveloperProfile.create_or_update_by_name("Developer A Profile", 
  :user => u_dA, :location => location_dA, :description => "A rocking developer")
  
email = "user@developerb.com"
u_dB = User.find_or_create_by_email(email, :password => email)
location_dB = Location.find_or_create_by_address1("145 West 44th St", 
  :city => "New York", :state => "NY", :post_code => "10036")
profile_dB = DeveloperProfile.create_or_update_by_name("Developer B Profile", 
  :user_id => u_dB.id, :location => location_dB, :description => "Bark") 

email = "user@developerc.com"
u_dC = User.find_or_create_by_email(email, :password => email)
location_dC = Location.find_or_create_by_address1("54 West 21st Street", 
  :city => "New York", :state => "NY", :post_code => "10010")
profile_dC = DeveloperProfile.find_or_create_by_name("Developer C Profile", 
  :user_id => u_dC.id, :location_id => location_dC.id, :description => "Creators")

email = "user@developerd.com"
u_dD = User.find_or_create_by_email(email, :password => email)
location_dD = Location.find_or_create_by_address1("459 Columbus Avenue", 
  :city => "New York", :state => "NY", :post_code => "10024")
profile_dD = DeveloperProfile.find_or_create_by_name("Developer D Profile", 
  :user_id => u_dD.id, :location_id => location_dD.id)

email = "user@developere.com"
u_dE = User.find_or_create_by_email(email, :password => email)
location_dE = Location.find_or_create_by_address1("3 East 43rd Street", 
  :city => "New York", :state => "NY", :post_code => "10017")
profile_dE = DeveloperProfile.find_or_create_by_name("Developer E Profile", 
  :user_id => u_dE.id, :location_id => location_dE.id)

email = "user@developerf.com"
u_dF = User.find_or_create_by_email(email, :password => email)
location_dF = Location.find_or_create_by_address1("304 Park Avenue South", 
  :city => "New York", :state => "NY", :post_code => "10010")
profile_dF = DeveloperProfile.find_or_create_by_name("Developer F Profile", 
  :user_id => u_dF.id, :location_id => location_dF.id)
