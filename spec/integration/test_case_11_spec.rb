require 'spec_helper'

describe 'Test Case 11 Credits' do
  fixtures:all
  it 'Verifies the User can Successfully purchase credits to bid' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')

    click_link "Credits"
    page.find(:xpath, './/a[@href="/credits/new?package=0"]').click
    select('Visa', :from => 'payment_credit_card_type')
    fill_in 'payment_credit_first_name', :with => 'Test'
    fill_in 'payment_credit_last_name', :with => 'Test'
    fill_in 'payment_credit_card_number', :with => '4111111111111111'
    fill_in 'payment_credit_card_verification', :with => '111'
    fill_in 'payment_credit_card_billing_zip', :with => '60126'
    select('2013', :from => 'payment_credit_card_expires_on_1i')
    select('6 - June', :from => 'payment_credit_card_expires_on_2i')
    click_button "Submit Payment"
    find('.alert-message').should have_content('Thank you for your payment.')
    click_link "Notifications"
    click_link "Account"
    click_link "Purchase History"
    click_link "View"
    
    log_out
  end
end
