require 'spec_helper'

describe 'Test Case 4 Test Viewing of Profile' do
  fixtures:all
  it 'Verifies the User can Successfully View a Profile' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')
    
    click_link "Browse"
    click_link "Contractors"
    page.find('.search_result:nth-child(2) .result_body .result_name a').should have_content('Contractor_ I Profile')
    page.find('.search_result:nth-child(4) .result_body .result_name a').should have_content('Contractor_ Ii Profile')
    page.find('.search_result:nth-child(6) .result_body .result_name a').should have_content('Contractor_ Iii Profile')
    page.find('.search_result:nth-child(8) .result_body .result_name a').should have_content('Contractor_ Iv Profile')
    page.find('.search_result:nth-child(10) .result_body .result_name a').should have_content('Contractor_ V Profile')

    log_out
  end
end
