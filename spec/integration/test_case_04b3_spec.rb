require 'spec_helper'

describe 'Test Case 4b3 Deleting a Profile and Verifying it was deleted and then redirects to a public page.' do
fixtures:all
  it 'welcomes the user' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "Notifications"
    click_link "Deactivate your account"
    end
end 