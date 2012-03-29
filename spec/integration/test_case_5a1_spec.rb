require 'spec_helper'

describe 'Test Case 5a1 Verify User is Able to Click Post a Project Button and is Directed to Post a Project Page' do
fixtures:all
  it 'welcomes the user' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link 'Post a Project'
    page.should have_content('Post a Project')
    end
 end