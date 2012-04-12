require 'spec_helper'

describe 'Test Case 1b1 Verifies the Profile Page is Displaying Correctly' do
  fixtures:all
  it 'Loads the Profile Page and Tests to make sure it linking to the proper page' do
    visit '/'
    page.should have_content('Building Relationships')
    log_in_as 'user@developera.com', 'user@developera.com'

    page.should have_content('Dashboard')
    click_link "Profile"
    page.should have_content('Company Overview')

    log_out
  end
end  
