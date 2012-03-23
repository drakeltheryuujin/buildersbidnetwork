require 'spec_helper'

describe 'Test Case 4 Test Viewing of Profie' do
fixtures:all
  it 'Verifies the User can Successfully purchase a Subscription' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_button "Company Overview"
    page.should have_content('Company Description')
    click_button "Projects Posted"
    end
end