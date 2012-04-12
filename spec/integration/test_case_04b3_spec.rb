require 'spec_helper'

describe 'Test Case 4b3 Deleting a Profile and Verifying it was deleted and then redirects to a public page.' do
  fixtures:all
  it 'welcomes the user' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')

    click_link "Notifications"
    pending "test account deleting"
    #click_link "Deactivate your account"
    
    log_out
  end
end 
