require 'spec_helper'

describe 'Test Case 3 Test Profile Registration' do
fixtures:all
  it 'Verifies the User can Successfully View a Profile' do
    visit '/'
 
    # 3a1 Test registration e-mail and password validation
    click_button "Create Account"
    fill_in 'user_email', :with => ''
    fill_in 'user_password', :with => ''
    fill_in 'user_password_confirmation', :with => ''
    click_button "Create Account"
    find('.alert-message').should have_content('2 errors prohibited this user from being saved:')
    
    # 3a2 Test registration password validation confirmation
    visit '/'
    click_button "Create Account"
    fill_in 'user_email', :with => 'test@test.com'
    click_button "Create Account"
    find('.alert-message').should have_content('1 error prohibited this user from being saved:')
    
    #3a3 Test registration password validation length
     visit '/'
     click_button "Create Account"
     fill_in 'user_email', :with => 'test@test.com'
     fill_in 'user_password', :with => 'test'
     find('.alert-message').should have_content('1 error prohibited this user from being saved:')
     
     #3a4 Test registration with valid fields
    click_button "Create Account"
    fill_in 'user_email', :with => 'michael@domandtom.com'
    fill_in 'user_password', :with => 'micahel@domandtom.com'
    fill_in 'user_password_confirmation', :with => 'michael@domandtom.com'
    click_button "Create Account"
    find('.alert-message').should have_content('2 errors prohibited this user from being saved:')
    end
end