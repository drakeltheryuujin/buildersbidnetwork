require 'spec_helper'

describe 'Test Case 3 Test Profile Registration' do
fixtures:all
  before(:all) do
    Capybara.current_driver = :rack_test
  end
  after(:all) do
    Capybara.use_default_driver
  end

  it 'Verifies the User can Successfully View a Profile', :js => false do
  
    # 3a1 Test registration e-mail and password validation
    visit '/'
    click_link "Sign Up"
    within ".login-box" do
      fill_in 'user_email', :with => ''
      fill_in 'user_password', :with => ''
      fill_in 'user_password_confirmation', :with => ''
    end
    click_button "Create Account"
    find('.alert-message').should have_content("Email can't be blank")
    find('.alert-message').should have_content("Password can't be blank")
    
    # 3a2 Test registration password validation confirmation
    visit '/'
    click_link "Sign Up"
    within ".login-box" do
      fill_in 'user_email', :with => 'test@test.com'
    end  
    click_button "Create Account"
    find('.alert-message').should have_content("Password can't be blank")
    
    #3a3 Test registration password validation length
     visit '/'
     click_link "Sign Up"
     within ".login-box" do
      fill_in 'user_email', :with => 'test@test.com'
      fill_in 'user_password', :with => 'test'
     end 
     click_button "Create Account"
     find('.alert-message').should have_content("Password is too short (minimum is 6 characters)")
     
     
    #3a4 Test registration with valid fields
    visit '/' 
    click_link "Sign Up"
    within ".login-box" do
      fill_in 'user_email', :with => 'test@test.com'
      fill_in 'user_password', :with => 'test1234'
      fill_in 'user_password_confirmation', :with => 'test1234'
    end  
    click_button "Create Account"
    find('.alert-message').should have_content("You have signed up successfully. Please check your inbox for a confirmation email and follow steps to verify your email address.")
    
     #3b1 Test received email
# Will find an email sent to test@example.com
# and set `current_email`
open_email('test@test.com')
current_email.should have_content 'Welcome'
current_email.save_and_open
current_email.click_link 'Confirm my account'
page.should have_content 'test@test.com'
find('.alert-message').should have_content("Your account was successfully confirmed. You are now signed in.")

#3c1 Complete registration
visit '/'
click_link "Log In"
within ".login-box" do
fill_in 'user_email', :with => 'test@test.com'
fill_in 'user_password', :with => 'test1234'
end
click_button 'Log in'
find('.alert-message').should have_content("Password is too short (minimum is 6 characters)")

#3d1 Test Profile update with invalid fields


#3d2 Test Profile update with valid fields
    
   end
end
