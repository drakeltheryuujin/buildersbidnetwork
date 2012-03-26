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
    click_link "Notifications"
    click_link "Activity"
    click_link "Active"
    end
end