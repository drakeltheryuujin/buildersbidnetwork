require 'spec_helper'

describe 'Test Case 4b Editing the Profile' do
fixtures:all
  it 'welcomes the user' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "Profile"
    click_link 'Edit Profile'
    fill_in 'developer_profile_name', :with => ' '
    fill_in 'developer_profile_location_attributes_address1', :with => ' '
    fill_in 'developer_profile_location_attributes_address2', :with => ' '
    fill_in 'developer_profile_location_attributes_city', :with => ' '
    fill_in 'developer_profile_location_attributes_post_code', :with => ' '
    fill_in 'developer_profile_website', :with => ' '
    click_button 'Save Profile'
      find('.alert-message.block-message.error').should have_content("errors prohibited this profile from being saved:")
      find('.alert-message.block-message.error').should have_content("Name can't be blank")
      find('.alert-message.block-message.error').should have_content("Location is invalid")
      find('.alert-message.block-message.error').should have_content("Location address1 can't be blank")
      find('.alert-message.block-message.error').should have_content("Location city can't be blank")
      find('.alert-message.block-message.error').should have_content("Location post code can't be blank")
      find('.alert-message.block-message.error').should have_content("Location post code should be 12345 or 12345-1234")
  end
end    