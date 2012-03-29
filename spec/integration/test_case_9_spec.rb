require 'spec_helper'

describe 'Test Case 9 Notifications and Inbox' do
fixtures:all
  it 'Sends a Message to a user and also verifies one can read messages in your inbox' do
    visit '/'
    fill_in 'user_email', :with => 'user@contractori.com'
    find_field('user_email').value.should == 'user@contractori.com' 
    fill_in 'Password', :with => 'user@contractori.com'
    find_field('Password').value.should == 'user@contractori.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    
     # Test Case 9a User can send a message to Contractor Project Owner 
    click_link "Browse"
    click_link "Developer B Project 2"
    click_link 'Send A Message'
    page.find('#contact-creator-modal').visible?
    fill_in "message_body", :with => 'This is a Test Message to Verify the send message is working correctly'
    click_link "Send"
    page.should have_content('Project Scope')
    page.find('a.dropdown-toggle').click
    click_link "Logout"
    
    # Test Case 9b User can read received messages/notifications and is displayed on the Dashboard
    # Test Case 9c User receives notifications on project milestones/events/activity in the Inbox
    visit '/'
    fill_in 'user_email', :with => 'user@developerb.com'
    find_field('user_email').value.should == 'user@developerb.com' 
    fill_in 'Password', :with => 'user@developerb.com'
    find_field('Password').value.should == 'user@developerb.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "My BBN"
    click_link "Notifications"
    click_link "Message regarding Developer B Project 2 from Contractor_ I Profile" 
  end
end