require 'spec_helper'

describe 'Test Case 12 Purchase Subscription' do
  fixtures:all
  it 'Verifies the User can Successfully purchase a Subscription' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')

    click_link "Credits"
    click_link "Buy a Subscription"
    page.find(:xpath, './/a[@href="/subscriptions/new?package=monthly"]').click
    select('Visa', :from => 'subscription_payment_card_type')
    fill_in 'subscription_payment_first_name', :with => 'Test'
    fill_in 'subscription_payment_last_name', :with => 'Account'
    fill_in 'subscription_payment_card_number', :with => '4111111111111111'
    fill_in 'subscription_payment_card_verification', :with => '111'
    fill_in 'subscription_payment_card_billing_zip', :with => '60126'
    select('2013', :from => 'subscription_payment_card_expires_on_1i')
    select('6 - June', :from => 'subscription_payment_card_expires_on_2i')
    click_button "Submit Payment"
    find('.alert-message').should have_content('Thank you for your payment.')
    click_link "Notifications"
    click_link "Account"
    click_link "Purchase History"
    click_link "View"

    log_out
  end
end
