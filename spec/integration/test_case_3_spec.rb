require 'spec_helper'

describe 'Test Case 3 Test Profile Registration' do
fixtures:all
  it 'Verifies the User can Successfully View a Profile' do
  
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
      fill_in 'user_password', :with => 'test@test.com'
      fill_in 'user_password_confirmation', :with => 'test@test.com'
    end  
    click_button "Create Account"
    find('.alert-message').should have_content("You have signed up successfully. Please check your inbox for a confirmation email and follow steps to verify your email address.")
    
    #3b1 Test received email
    
   end
end