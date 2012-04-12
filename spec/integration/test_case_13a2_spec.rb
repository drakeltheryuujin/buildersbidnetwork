require 'spec_helper'

describe 'Test Case 13a2 Viewing a Private Project' do
fixtures:all
  it 'Views a Private Project and Verifies only Invited People and Project Owner Can view this project' do
    visit '/'
    log_in_as 'user@contractori.com', 'user@contractori.com'
    page.should have_content('Dashboard')
    click_link "My BBN"
    click_link "Notifications"
    click_link "Invite Only"
    click_link "Browse"
    pending 'needs tests'

    log_out
  end
end
