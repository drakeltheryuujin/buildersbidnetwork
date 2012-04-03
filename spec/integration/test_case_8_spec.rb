require 'spec_helper'

describe 'Test Case 8 Bid Award' do
fixtures:all
  it 'Allow project owner to award bid, and have users accept awarded bid' do
     visit '/'
       fill_in 'user_email', :with => 'user@contractori.com'
         find_field('user_email').value.should == 'user@contractori.com' 
       fill_in 'Password', :with => 'user@contractori.com'
         find_field('Password').value.should == 'user@contractori.com' 
      click_button 'Login'
     page.should have_content('Dashboard')
     click_link "Browse"
       click_link "Developer E Project 5"
         click_link "Enter Bid"
           fill_in 'bid_line_item_bids_attributes_0_cost' , :with => '1'  
           fill_in 'bid_line_item_bids_attributes_1_unit_cost' , :with => '2'
           fill_in 'bid_line_item_bids_attributes_2_cost' , :with => '3'  
           fill_in 'bid_line_item_bids_attributes_3_unit_cost' , :with => '4'
           fill_in 'bid_line_item_bids_attributes_4_cost' , :with => '5'  
           fill_in 'bid_line_item_bids_attributes_5_unit_cost' , :with => '6'
           fill_in 'bid_line_item_bids_attributes_6_cost' , :with => '7'  
           fill_in 'bid_line_item_bids_attributes_7_unit_cost' , :with => '8'
           fill_in 'bid_line_item_bids_attributes_8_cost' , :with => '9'  
           fill_in 'bid_line_item_bids_attributes_9_unit_cost' , :with => '10'
     click_button "Publish Bid"
       find('.alert-message').should have_content('Bid was successfully created as Draft.')
      page.find('a.dropdown-toggle').click
         click_link "Logout"

    visit '/'
      fill_in 'user_email', :with => 'admin@admin.com'
        find_field('user_email').value.should == 'admin@admin.com' 
      fill_in 'Password', :with => 'admin@admin.com'
        find_field('Password').value.should == 'admin@admin.com' 
      click_button 'Login'
       visit '/admin/projects/962142065'  
      click_link "End Bidding"
          click_button 'OK'
            find('.flash_notice').should have_content("Bidding Ended!")
    page.find('a.dropdown-toggle').click
    click_link "Logout"
    # 1. Project Owner are able to AWARD BID to a Contractor 
      click_link "My BBN"
        click_link "Developer A Project 1"
          click_link "Bids"
            click_button 'Bid Details'
              click_button 'Award Project'
      page.find('a.dropdown-toggle').click
        click_link "Logout"     
    # 2. Contractor able to VIEW BID AWARD NOTIFICATION
       visit '/'
      fill_in 'user_email', :with => 'user@contractori.com'
        find_field('user_email').value.should == 'user@contractori.com' 
      fill_in 'Password', :with => 'user@contractori.com'
        find_field('Password').value.should == 'user@contractori.com' 
      click_button 'Login'
    page.should have_content('Dashboard')
      click_link "Notifications"
      click_link "Activity"
      click_link "Active"
      click_link "Developer E Project 5"
      click_link 'Send A Message'
        page.find('#contact-creator-modal').visible?
          fill_in "message_body", :with => 'This is a Test Message to Verify the Send Message Notification is working correctly'
        click_link "Send"
      click_link "Notifications"
    
    # 3. Contractor able to NAVIGATE TO BID AWARD PROJECT from NOTIFICATION
        visit '/'
        page.should have_content('Dashboard')
          click_link "Notifications"
            click_link "You've been awarded Test Private Project 1a"
              click_link "Accept or Decline"
                click_button 'Accept Project' 
                  click_button 'Send' 
    # 4. Contractor able to ACCEPT BID AWARD for a PROJECT
        click_link "You've been awarded Test Private Project 1a"
          click_link "Accept or Decline"
            click_button 'Accept Project'
              fill_in "message_body", :with => 'I have decided to Accept the bid award on this project.' 
            click_button 'Send' 
            find('.alert-message').should have_content("Bid Accepted")
    # 5. Contractor able to DECLINE BID AWARD for a PROJECT
        click_link "You've been awarded Test Private Project 1a"
          click_link "Accept or Decline"
            click_button 'Decline Project'
              fill_in "message_body", :with => 'I have decided to Decline the bid award on this project. Thanks for keeping me in mind for this project.' 
          click_button 'Send' 
            find('.alert-message').should have_content("Bid Declined")
        page.find('a.dropdown-toggle').click
          click_link "Logout"  
    # 6. Project Owner receive BID DECLINED NOTIFICATION when CONTRACTOR DECLINES BID AWARD 
      visit '/'
        fill_in 'user_email', :with => 'user@contractori.com'
          find_field('user_email').value.should == 'user@contractori.com' 
        fill_in 'Password', :with => 'user@contractori.com'
          find_field('Password').value.should == 'user@contractori.com' 
        click_button 'Login'
      page.should have_content('Dashboard')
    # 7. Project Owner are able to RE-AWARD BID to a Contractor (same as Test 8.1) 
    end
end