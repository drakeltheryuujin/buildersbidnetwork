require 'spec_helper'

describe 'Test Case 1b2 Verifies the Profile Page is Displaying Correctly and All other Non-Public Pages' do
fixtures:all
  it 'Loads the Profile Page, and all other Non-Public Pages and Verifies it links to the right pages' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "Profile"
    page.should have_content('Company Overview')
    click_link "Notifications"
    page.should have_content('My Notifications')
    click_link "Browse"
    page.should have_content('Browse Projects')
    click_link "My BBN"
    page.should have_content('Track My Projects')
    click_link "Credits"
    page.should have_content('How do credits work?')
    end
end  