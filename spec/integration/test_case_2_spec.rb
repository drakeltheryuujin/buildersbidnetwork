require 'spec_helper'

describe 'Test Case 4 Test Viewing of Profile' do
fixtures:all
  it 'Verifies the User can Successfully View a Profile' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    
    click_link "Browse"
    click_link "Contractors"
    page.find('.result_name:nth-child(1)').should have_content('Contractor_ I Profile')
    end
  end