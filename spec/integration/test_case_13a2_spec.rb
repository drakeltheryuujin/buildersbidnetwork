require 'spec_helper'

describe 'Test Case 13a2 Viewing a Private Project' do
fixtures:all
  it 'Views a Private Project and Verifies only Invited People and Project Owner Can view this project' do
    visit '/'
    fill_in 'user_email', :with => 'user@contractori.com'
    find_field('user_email').value.should == 'user@contractori.com' 
    fill_in 'Password', :with => 'user@contractori.com'
    find_field('Password').value.should == 'user@contractori.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "My BBN"
    click_link "Notifications"
    click_link "Invite Only"
    click_link "Browse"
    end
 end