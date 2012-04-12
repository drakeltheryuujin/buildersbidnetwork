require 'spec_helper'

describe 'Test Case 9 Notifications and Inbox' do
  fixtures:all
  it 'Sends a Message to a user and also verifies one can read messages in your inbox' do
    visit '/'
    log_in_as 'user@contractori.com', 'user@contractori.com'
    page.should have_content('Dashboard')
    
     # Test Case 9a User can send a message to Contractor Project Owner 
    click_link "Browse"
    click_link "Developer B Project 2"
    click_link 'Send A Message'
    wait_until { page.find('#contact-creator-modal').visible? }
    fill_in "message_body", :with => 'This is a Test Message to Verify the send message is working correctly'
    within '#contact-creator-modal' do
      click_button "Send"
    end
    wait_until { page.find('.alert-message').visible? }
    page.find('.alert-message').should have_content('Message Sent')
    log_out
    
    # Test Case 9b User can read received messages/notifications and is displayed on the Dashboard
    # Test Case 9c User receives notifications on project milestones/events/activity in the Inbox
    visit '/'
    log_in_as 'user@developerb.com', 'user@developerb.com'
    page.should have_content('Dashboard')
    click_link "Notifications"
    click_link "Message regarding Developer B Project 2 from Contractor_ I Profile" 

    log_out
  end
end
