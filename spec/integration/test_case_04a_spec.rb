require 'spec_helper'

describe 'Test Case 4 Test Viewing of Profie' do
fixtures:all
  it 'Verifies the User can Successfully View a Profile' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')

    click_link "Profile"
    click_link "Company Overview"
    page.should have_content('Company Description')
    click_link "Posted Projects"

    log_out
  end
end
