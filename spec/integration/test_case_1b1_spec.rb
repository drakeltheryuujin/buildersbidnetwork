require 'spec_helper'

describe 'Test Case 1b1 Verifies the Profile Page is Displaying Correctly' do
fixtures:all
  it 'Loads the Profile Page and Tests to make sure it linking to the proper page' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "Profile"
    page.should have_content('Company Overview')
    end
end  