require 'spec_helper'

describe 'Test Case 4b2 Editing the Profile Fields with Valid Information and Verifying it Saves the Data' do
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
    fill_in 'developer_profile_name', :with => 'John Doe'
    fill_in 'developer_profile_location_attributes_address1', :with => '123 Anywhere Lane'
    fill_in 'developer_profile_location_attributes_address2', :with => 'Suite 2122'
    fill_in 'developer_profile_location_attributes_city', :with => 'Chicago'
    select('Illinois', :from => 'developer_profile_location_attributes_state')
    fill_in 'developer_profile_location_attributes_post_code', :with => '60126'
    fill_in 'developer_profile_website', :with => 'www.johndoeinc.com'
    fill_in 'developer_profile_description', :with => 'I Develop Mobile Applications, and Websites'
    click_button 'Save Profile'
      find('.alert-message').should have_content('Profile was successfully updated')
      assert_equal 'John Doe', 'John Doe'
      assert_equal '123 Anywhere Lane', '123 Anywhere Lane'
      assert_equal 'Suite 2122', 'Suite 2122'
      assert_equal 'Chicago' , 'Chicago'
      assert_equal 'Illinois', 'Illinois' 
      assert_equal '60126', '60126'
      assert_equal 'www.johndoeinc.com', 'www.johndoeinc.com'
      assert_equal 'I Develop Mobile Applications, and Websites', 'I Develop Mobile Applications, and Websites'
  end
end    