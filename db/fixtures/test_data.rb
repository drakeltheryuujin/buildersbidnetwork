class << ActiveRecord::Base
	def create_or_update_by_name(name, options = {})
    record = find_by_name(name) || new
    record.name = name
    record.attributes = options
    record.save!
    
    record
  end

  def find_or_new_by_user_and_project(user, project, options = {})
    record = where(:user_id => user.id, :project_id => project.id).first || new
    record.user = user
    record.project = project
    record.attributes = options
    
    record
  end
end

def randomize_offsets 
  $bid_end_offset_days         = 1 + rand(100)
  $pre_bid_meeting_offset_days = 1 + rand(25)
  $project_start_offset_days   = 1 + $bid_end_offset_days + rand(100)
  $project_end_offset_days     = $project_start_offset_days + rand(500)
  $estimated_budget            = 5000 + rand(100000)
  case $estimated_budget
  when 0..50000
    $credit_value                = 1
  when 50001..100000
    $credit_value                = 2
  when 100001..250000
    $credit_value                = 3
  when 250001..500000
    $credit_value                = 4
  else
    $credit_value                = 5
  end
end

def populate_and_save_bid!(bid)
  project = bid.project
  project.line_items.each do |li|
    c = 0
    if li.units.present?
      uc = (1 + rand(100))
      c = uc * li.units
      puts "(#{c})\t[#{li.units}]\t{#{uc}}"
      bid.line_item_bids.build({:line_item => li, :unit_cost => uc, :cost => c})
    else
      c = (1 + rand(100))
      puts "(#{c})"
      bid.line_item_bids.build({:line_item => li, :cost => c})
    end
    bid.total += c
    puts bid.total
  end
  puts "--"
  bid.save!
  bid.publish!
end

NOW = Time.now
TODAY = Date.today
DAY_IN_SECONDS = (60 * 60 * 24)


# ADMIN
email = "contact@builderbidnetwork.com"
u_admin = User.find_or_create_by_email(email, :password => email)
u_admin.update_attribute :admin, true
location_admin = Location.find_or_create_by_address1("36 Cooper Sq", :city => "New York", :state => "NY", :post_code => "10003")
profile_admin = ContractorProfile.create_or_update_by_name("Admin Profile", 
  :user_id => u_admin.id, :location_id => location_admin.id)


# CONTRACTORS
email = "user@contractori.com"
u_cI = User.find_or_create_by_email(email, :password => email)
location_cI = Location.find_or_create_by_address1("547 WEST 27TH ST", 
  :city => "New York", :state => "NY", :post_code => "10001")
profile_cI = ContractorProfile.create_or_update_by_name("Contractor I Profile", 
  :user_id => u_cI.id, :location_id => location_cI.id)
gc_cI = GrantedCredit.create(:value => 50, :user_id => u_cI.id, :granted_by_id => u_admin.id)

email = "user@contractorii.com"
u_cII = User.find_or_create_by_email(email, :password => email)
location_cII = Location.find_or_create_by_address1("122 East 42nd Street",
  :city => "New York", :state => "NY", :post_code => "10168")
profile_cII = ContractorProfile.create_or_update_by_name("Contractor II Profile", 
  :user_id => u_cII.id, :location_id => location_cII.id)
gc_cII = GrantedCredit.create(:value => 50, :user_id => u_cII.id, :granted_by_id => u_admin.id)

email = "user@contractoriii.com"
u_cIII = User.find_or_create_by_email(email, :password => email)
location_cIII = Location.find_or_create_by_address1("45 Christopher Street",
  :city => "New York", :state => "NY", :post_code => "10014")
profile_cIII = ContractorProfile.create_or_update_by_name("Contractor III Profile", 
  :user_id => u_cIII.id, :location_id => location_cIII.id)
gc_cIII = GrantedCredit.create(:value => 50, :user_id => u_cIII.id, :granted_by_id => u_admin.id)

email = "user@contractoriv.com"
u_cIV = User.find_or_create_by_email(email, :password => email)
location_cIV = Location.find_or_create_by_address1("4 East 81st Street",
  :city => "New York", :state => "NY", :post_code => "10028")
profile_cIV = ContractorProfile.create_or_update_by_name("Contractor IV Profile", 
  :user_id => u_cIV.id, :location_id => location_cIV.id)
gc_cIV = GrantedCredit.create(:value => 50, :user_id => u_cIV.id, :granted_by_id => u_admin.id)

email = "user@contractorv.com"
u_cV = User.find_or_create_by_email(email, :password => email)
location_cV = Location.find_or_create_by_address1("625 West 51st Street",
  :city => "New York", :state => "NY", :post_code => "10019")
profile_cV = ContractorProfile.create_or_update_by_name("Contractor V Profile", 
  :user_id => u_cV.id, :location_id => location_cV.id)
gc_cV = GrantedCredit.create(:value => 50, :user_id => u_cV.id, :granted_by_id => u_admin.id)



# DEVELOPERS & PROJECTS
email = "user@developera.com"
u_dA = User.find_or_create_by_email(email, :password => email)
location_dA = Location.find_or_create_by_address1("200 Varick St", 
  :address2 => "10th Floor", :city => "New York", :state => "NY", :post_code => "10014")
profile_dA = DeveloperProfile.create_or_update_by_name("Developer A Profile", 
  :user => u_dA, :location => location_dA, :description => "A rocking developer")

randomize_offsets
location_dA1 = Location.find_or_create_by_address1("21 Astor Pl",
  :city => "New York", :state => "NY", :post_code => "10003")
project_dA1 = Project.create_or_update_by_name("Developer A Project 1",
  :user => u_dA, :location => location_dA1, :project_type_id => 1,
  :description => "Developer A Project 1 Description", :notes => "Developer A Project 1 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA1 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA1 Li2'}),
    LineItem.new({:content => 'p_dA1 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA1 Li4'}),
    LineItem.new({:content => 'p_dA1 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA1 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA1 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA1 Li8'}),
    LineItem.new({:content => 'p_dA1 Li9'})
  ])
bid_dA1_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dA1, {:total => 0})
populate_and_save_bid!(bid_dA1_cI)

bid_dA1_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dA1, {:total => 0})
populate_and_save_bid!(bid_dA1_cII)

bid_dA1_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dA1, {:total => 0})
populate_and_save_bid!(bid_dA1_cIII)

bid_dA1_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dA1, {:total => 0})
populate_and_save_bid!(bid_dA1_cIV)

bid_dA1_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dA1, {:total => 0})
populate_and_save_bid!(bid_dA1_cV)



randomize_offsets
location_dA2 = Location.find_or_create_by_address1("11 Waverly Pl",
  :city => "New York", :state => "NY", :post_code => "10003")
project_dA2 = Project.create_or_update_by_name("Developer A Project 2",
  :user => u_dA, :location => location_dA2, :project_type_id => 2,
  :description => "Developer A Project 2 Description", :notes => "Developer A Project 2 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA2 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA2 Li2'}),
    LineItem.new({:content => 'p_dA2 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA2 Li4'}),
    LineItem.new({:content => 'p_dA2 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA2 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA2 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA2 Li8'}),
    LineItem.new({:content => 'p_dA2 Li9'})
  ])
bid_dA2_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dA2, {:total => 0})
populate_and_save_bid!(bid_dA2_cI)

bid_dA2_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dA2, {:total => 0})
populate_and_save_bid!(bid_dA2_cII)

bid_dA2_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dA2, {:total => 0})
populate_and_save_bid!(bid_dA2_cIII)

bid_dA2_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dA2, {:total => 0})
populate_and_save_bid!(bid_dA2_cIV)

bid_dA2_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dA2, {:total => 0})
populate_and_save_bid!(bid_dA2_cV)


randomize_offsets
location_dA3 = Location.find_or_create_by_address1("1211 29th Ave",
  :city => "Astoria", :state => "NY", :post_code => "11102")
project_dA3 = Project.create_or_update_by_name("Developer A Project 3",
  :user => u_dA, :location => location_dA3, :project_type_id => 3,
  :description => "Developer A Project 3 Description", :notes => "Developer A Project 3 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA3 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA3 Li2'}),
    LineItem.new({:content => 'p_dA3 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA3 Li4'}),
    LineItem.new({:content => 'p_dA3 Li5'})
  ])
bid_dA3_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dA3, {:total => 0})
populate_and_save_bid!(bid_dA3_cI)

bid_dA3_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dA3, {:total => 0})
populate_and_save_bid!(bid_dA3_cII)

bid_dA3_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dA3, {:total => 0})
populate_and_save_bid!(bid_dA3_cIV)



randomize_offsets
location_dA4 = Location.find_or_create_by_address1("3809 Ditmars Boulevard",
  :city => "Astoria", :state => "NY", :post_code => "11105")
project_dA4 = Project.create_or_update_by_name("Developer A Project 4",
  :user => u_dA, :location => location_dA4, :project_type_id => 4,
  :description => "Developer A Project 4 Description", :notes => "Developer A Project 4 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA4 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA4 Li2'}),
    LineItem.new({:content => 'p_dA4 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dA4 Li4'}),
    LineItem.new({:content => 'p_dA4 Li5'})
  ])
bid_dA4_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dA4, {:total => 0})
populate_and_save_bid!(bid_dA4_cI)

bid_dA4_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dA4, {:total => 0})
populate_and_save_bid!(bid_dA4_cII)

bid_dA4_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dA4, {:total => 0})
populate_and_save_bid!(bid_dA4_cIII)

bid_dA4_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dA4, {:total => 0})
populate_and_save_bid!(bid_dA4_cIV)

bid_dA4_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dA4, {:total => 0})
populate_and_save_bid!(bid_dA4_cV)


randomize_offsets
location_dA5 = Location.find_or_create_by_address1("94-18 Roosevelt Avenue",
  :city => "Flushing", :state => "NY", :post_code => "11372")
project_dA5 = Project.create_or_update_by_name("Developer A Project 5",
  :user => u_dA, :location => location_dA5, :project_type_id => 5,
  :description => "Developer A Project 5 Description", :notes => "Developer A Project 5 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:content => 'p_dA5 Li1'}),
    LineItem.new({:content => 'p_dA5 Li2'}),
    LineItem.new({:content => 'p_dA5 Li3'}),
    LineItem.new({:content => 'p_dA5 Li4'}),
    LineItem.new({:content => 'p_dA5 Li5'}),
    LineItem.new({:content => 'p_dA5 Li6'}),
    LineItem.new({:content => 'p_dA5 Li7'}),
    LineItem.new({:content => 'p_dA5 Li8'}),
    LineItem.new({:content => 'p_dA5 Li9'})
  ])
bid_dA5_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dA5, {:total => 0})
populate_and_save_bid!(bid_dA5_cV)


  
email = "user@developerb.com"
u_dB = User.find_or_create_by_email(email, :password => email)
location_dB = Location.find_or_create_by_address1("145 West 44th St", 
  :city => "New York", :state => "NY", :post_code => "10036")
profile_dB = DeveloperProfile.create_or_update_by_name("Developer B Profile", 
  :user_id => u_dB.id, :location_id => location_dB.id, :description => "Bark") 

randomize_offsets
location_dB1 = Location.find_or_create_by_address1("40 Enterprise Avenue North",
  :city => "Secaucus", :state => "NJ", :post_code => "07094")
project_dB1 = Project.create_or_update_by_name("Developer B Project 1",
  :user => u_dB, :location => location_dB1, :project_type_id => 1,
  :description => "Developer B Project 1 Description", :notes => "Developer B Project 1 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB1 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB1 Li2'}),
    LineItem.new({:content => 'p_dB1 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB1 Li4'}),
    LineItem.new({:content => 'p_dB1 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB1 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB1 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB1 Li8'}),
    LineItem.new({:content => 'p_dB1 Li9'})
  ])
bid_dB1_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dB1, {:total => 0})
populate_and_save_bid!(bid_dB1_cI)

bid_dB1_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dB1, {:total => 0})
populate_and_save_bid!(bid_dB1_cII)

bid_dB1_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dB1, {:total => 0})
populate_and_save_bid!(bid_dB1_cIII)

bid_dB1_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dB1, {:total => 0})
populate_and_save_bid!(bid_dB1_cIV)

bid_dB1_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dB1, {:total => 0})
populate_and_save_bid!(bid_dB1_cV)


randomize_offsets
location_dB2 = Location.find_or_create_by_address1("120 State Rte 17",
  :city => "East Rutherford", :state => "NJ", :post_code => "07073")
project_dB2 = Project.create_or_update_by_name("Developer B Project 2",
  :user => u_dB, :location => location_dB2, :project_type_id => 2,
  :description => "Developer B Project 2 Description", :notes => "Developer B Project 2 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB2 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB2 Li2'}),
    LineItem.new({:content => 'p_dB2 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB2 Li4'}),
    LineItem.new({:content => 'p_dB2 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB2 Li6'})
  ])
bid_dB2_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dB2, {:total => 0})
populate_and_save_bid!(bid_dB2_cI)

bid_dB2_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dB2, {:total => 0})
populate_and_save_bid!(bid_dB2_cII)

bid_dB2_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dB2, {:total => 0})
populate_and_save_bid!(bid_dB2_cIII)

bid_dB2_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dB2, {:total => 0})
populate_and_save_bid!(bid_dB2_cIV)

bid_dB2_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dB2, {:total => 0})
populate_and_save_bid!(bid_dB2_cV)


randomize_offsets
location_dB3 = Location.find_or_create_by_address1("500 US Highway 46",
  :city => "Clifton", :state => "NJ", :post_code => "07011")
project_dB3 = Project.create_or_update_by_name("Developer B Project 3",
  :user => u_dB, :location => location_dB3, :project_type_id => 3,
  :description => "Developer B Project 3 Description", :notes => "Developer B Project 3 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB3 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB3 Li2'}),
    LineItem.new({:content => 'p_dB3 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB3 Li4'}),
    LineItem.new({:content => 'p_dB3 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB3 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB3 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB3 Li8'}),
    LineItem.new({:content => 'p_dB3 Li9'})
  ])

randomize_offsets
location_dB4 = Location.find_or_create_by_address1("1 Gardner Rd",
  :city => "Fairfield", :state => "NJ", :post_code => "07004")
project_dB4 = Project.create_or_update_by_name("Developer B Project 4",
  :user => u_dB, :location => location_dB4, :project_type_id => 4,
  :description => "Developer B Project 4 Description", :notes => "Developer B Project 4 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB4 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB4 Li2'}),
    LineItem.new({:content => 'p_dB4 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB4 Li4'}),
    LineItem.new({:content => 'p_dB4 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB4 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB4 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB4 Li8'}),
    LineItem.new({:content => 'p_dB4 Li9'}),
  ])
bid_dB4_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dB4, {:total => 0})
populate_and_save_bid!(bid_dB4_cI)

bid_dB4_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dB4, {:total => 0})
populate_and_save_bid!(bid_dB4_cV)



randomize_offsets
location_dB5 = Location.find_or_create_by_address1("189 State Route 502",
  :city => "Wayne", :state => "NJ", :post_code => "07470")
project_dB5 = Project.create_or_update_by_name("Developer B Project 5",
  :user => u_dB, :location => location_dB5, :project_type_id => 5,
  :description => "Developer B Project 5 Description", :notes => "Developer B Project 5 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB5 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dB5 Li2'})
  ])
bid_dB5_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dB5, {:total => 0})
populate_and_save_bid!(bid_dB5_cI)

bid_dB5_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dB5, {:total => 0})
populate_and_save_bid!(bid_dB5_cII)

bid_dB5_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dB5, {:total => 0})
populate_and_save_bid!(bid_dB5_cIII)

bid_dB5_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dB5, {:total => 0})
populate_and_save_bid!(bid_dB5_cIV)

bid_dB5_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dB5, {:total => 0})
populate_and_save_bid!(bid_dB5_cV)


 
email = "user@developerc.com"
u_dC = User.find_or_create_by_email(email, :password => email)
location_dC = Location.find_or_create_by_address1("54 West 21st Street", 
  :city => "New York", :state => "NY", :post_code => "10010")
profile_dC = DeveloperProfile.create_or_update_by_name("Developer C Profile", 
  :user_id => u_dC.id, :location_id => location_dC.id, :description => "Creators")

randomize_offsets
location_dC1 = Location.find_or_create_by_address1("11 Glen Cove Road",
  :city => "Greenvale", :state => "NY", :post_code => "11548")
project_dC1 = Project.create_or_update_by_name("Developer C Project 1",
  :user => u_dC, :location => location_dC1, :project_type_id => 1,
  :description => "Developer C Project 1 Description", :notes => "Developer C Project 1 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC1 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC1 Li2'}),
    LineItem.new({:content => 'p_dC1 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC1 Li4'}),
    LineItem.new({:content => 'p_dC1 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC1 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC1 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC1 Li8'}),
    LineItem.new({:content => 'p_dC1 Li9'})
  ])
bid_dC1_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dC1, {:total => 0})
populate_and_save_bid!(bid_dC1_cI)

bid_dC1_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dC1, {:total => 0})
populate_and_save_bid!(bid_dC1_cII)

bid_dC1_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dC1, {:total => 0})
populate_and_save_bid!(bid_dC1_cIII)

bid_dC1_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dC1, {:total => 0})
populate_and_save_bid!(bid_dC1_cIV)

bid_dC1_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dC1, {:total => 0})
populate_and_save_bid!(bid_dC1_cV)



randomize_offsets
location_dC2 = Location.find_or_create_by_address1("94 Gardiners Avenue",
  :city => "Levittown", :state => "NY", :post_code => "11756")
project_dC2 = Project.create_or_update_by_name("Developer C Project 2",
  :user => u_dC, :location => location_dC2, :project_type_id => 2,
  :description => "Developer C Project 2 Description", :notes => "Developer C Project 2 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC2 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC2 Li2'}),
    LineItem.new({:content => 'p_dC2 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dC2 Li4'})
  ])
bid_dC2_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dC2, {:total => 0})
populate_and_save_bid!(bid_dC2_cI)

bid_dC2_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dC2, {:total => 0})
populate_and_save_bid!(bid_dC2_cII)

bid_dC2_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dC2, {:total => 0})
populate_and_save_bid!(bid_dC2_cIII)

bid_dC2_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dC2, {:total => 0})
populate_and_save_bid!(bid_dC2_cV)



email = "user@developerd.com"
u_dD = User.find_or_create_by_email(email, :password => email)
location_dD = Location.find_or_create_by_address1("459 Columbus Avenue", 
  :city => "New York", :state => "NY", :post_code => "10024")
profile_dD = DeveloperProfile.create_or_update_by_name("Developer D Profile", 
  :user_id => u_dD.id, :location_id => location_dD.id)

randomize_offsets
location_dD1 = Location.find_or_create_by_address1("309 Main Street",
  :city => "Farmingdale", :state => "NY", :post_code => "11735")
project_dD1 = Project.create_or_update_by_name("Developer D Project 1",
  :user => u_dD, :location => location_dD1, :project_type_id => 1,
  :description => "Developer D Project 1 Description", :notes => "Developer D Project 1 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD1 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD1 Li2'}),
    LineItem.new({:content => 'p_dD1 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD1 Li4'}),
    LineItem.new({:content => 'p_dD1 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD1 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD1 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD1 Li8'}),
    LineItem.new({:content => 'p_dD1 Li9'})
  ])
bid_dD1_cI = Bid.find_or_new_by_user_and_project(u_cI, project_dD1, {:total => 0})
populate_and_save_bid!(bid_dD1_cI)

bid_dD1_cII = Bid.find_or_new_by_user_and_project(u_cII, project_dD1, {:total => 0})
populate_and_save_bid!(bid_dD1_cII)

bid_dD1_cIII = Bid.find_or_new_by_user_and_project(u_cIII, project_dD1, {:total => 0})
populate_and_save_bid!(bid_dD1_cIII)

bid_dD1_cIV = Bid.find_or_new_by_user_and_project(u_cIV, project_dD1, {:total => 0})
populate_and_save_bid!(bid_dD1_cIV)

bid_dD1_cV = Bid.find_or_new_by_user_and_project(u_cV, project_dD1, {:total => 0})
populate_and_save_bid!(bid_dD1_cV)


randomize_offsets
location_dD2 = Location.find_or_create_by_address1("211 Higbie Lane",
  :city => "West Islip", :state => "NY", :post_code => "11795")
project_dD2 = Project.create_or_update_by_name("Developer D Project 2",
  :user => u_dD, :location => location_dD2, :project_type_id => 2,
  :description => "Developer D Project 2 Description", :notes => "Developer D Project 2 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li2'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li4'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li8'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dD2 Li9'})
  ])


email = "user@developere.com"
u_dE = User.find_or_create_by_email(email, :password => email)
location_dE = Location.find_or_create_by_address1("3 East 43rd Street", 
  :city => "New York", :state => "NY", :post_code => "10017")
profile_dE = DeveloperProfile.create_or_update_by_name("Developer E Profile", 
  :user_id => u_dE.id, :location_id => location_dE.id)

randomize_offsets
location_dE1 = Location.find_or_create_by_address1("1420 Union Tpke",
  :city => "New Hyde Park", :state => "NY", :post_code => "11040")
project_dE1 = Project.create_or_update_by_name("Developer E Project 1",
  :user => u_dE, :location => location_dE1, :project_type_id => 1,
  :description => "Developer E Project 1 Description", :notes => "Developer E Project 1 Notes",
  :estimated_budget => $estimated_budget, :credit_value => $credit_value,
  :state => :published.to_s,
  :bidding_end     => NOW + (DAY_IN_SECONDS * $bid_end_offset_days), 
  :pre_bid_meeting => NOW + (DAY_IN_SECONDS * $pre_bid_meeting_offset_days),
  :project_start => TODAY + $project_start_offset_days, :project_end => TODAY + $project_end_offset_days,
  :line_items => [
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dE1 Li1'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dE1 Li2'}),
    LineItem.new({:content => 'p_dE1 Li3'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dE1 Li4'}),
    LineItem.new({:content => 'p_dE1 Li5'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dE1 Li6'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dE1 Li7'}),
    LineItem.new({:units => (1 + rand(1000)), :content => 'p_dE1 Li8'}),
    LineItem.new({:content => 'p_dE1 Li9'})
  ])


email = "user@developerf.com"
u_dF = User.find_or_create_by_email(email, :password => email)
location_dF = Location.find_or_create_by_address1("304 Park Avenue South", 
  :city => "New York", :state => "NY", :post_code => "10010")
profile_dF = DeveloperProfile.create_or_update_by_name("Developer F Profile", 
  :user_id => u_dF.id, :location_id => location_dF.id)



