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
    click_link "Notifications"
    click_link "Account"
    
    fill_in 'user_password', :with => '123456'
    fill_in 'user_password_confirmation', :with => '123456'
    fill_in 'user_current_password', :with => 'user@developera.com'
    click_button 'Update'
    find('.alert-message').should have_content('You updated your account successfully.')
    
    click_link "Notifications"
    click_link "Account"
    fill_in 'user_password', :with => ''
    fill_in 'user_password_confirmation', :with => ''
    fill_in 'user_current_password', :with => ''
    click_button 'Update'
    find('.alert-message').should have_content('error prohibited this user from being saved:')
    
    end
  end
    