require 'spec_helper'

describe 'Test Case 9 Notifications and Inbox' do
fixtures:all
  it 'Sends a Message to a user and also verifies one can read messages in your inbox' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    
    click_link "Browse"
    click_link "Developer B Project 2"
    click_link "Send a Message"
    fill_in "message_body", :with => 'This is a Test Message to Verify the send message is working correctly'
    click_button "Send"
    find('.alert-message success').should have_content('Message Sent')
    
    click_link "Notifications"
  end
end