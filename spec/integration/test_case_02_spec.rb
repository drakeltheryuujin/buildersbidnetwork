require 'spec_helper'

describe 'Test Case 4 Test Viewing of Profile' do
  fixtures:all
  it 'Verifies the User can Successfully View a Profile' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'

    page.should have_content('Dashboard')

    
    click_link "Browse"
    click_link "Contractors"
    page.find('.result_name:nth-child(1)').should have_content('Contractor_ Iii Profile') # Postgres has weird notions of how varchars should be ordered

    log_out
  end
end
