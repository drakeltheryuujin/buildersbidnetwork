require 'spec_helper'

describe 'Test Case 6 Test Viewing of Profile' do
fixtures:all
  it 'Gives the User Credits and a Subscription to Allow the Contractor to Bid on a Project' do
    visit '/'
    fill_in 'user_email', :with => 'user@contractori.com'
    find_field('user_email').value.should == 'user@contractori.com' 
    fill_in 'Password', :with => 'user@contractori.com'
    find_field('Password').value.should == 'user@contractori.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "Credits"
    page.find(:xpath, './/a[@href="/credits/new?package=0"]').click
    select('Visa', :from => 'payment_credit_card_type')
    fill_in 'payment_credit_first_name', :with => 'Test'
    fill_in 'payment_credit_last_name', :with => 'Credits'
    fill_in 'payment_credit_card_number', :with => '4111111111111111'
    fill_in 'payment_credit_card_verification', :with => '111'
    fill_in 'payment_credit_card_billing_zip', :with => '60126'
    select('2013', :from => 'payment_credit_card_expires_on_1i')
    select('6 - June', :from => 'payment_credit_card_expires_on_2i')
    click_button "Submit Payment"
    find('.alert-message').should have_content('Thank you for your payment.')
   
    click_link "Credits"
    click_link "Buy a Subscription"
    page.find(:xpath, './/a[@href="/subscriptions/new?package=monthly"]').click
    select('Visa', :from => 'subscription_payment_card_type')
    fill_in 'subscription_payment_first_name', :with => 'Test'
    fill_in 'subscription_payment_last_name', :with => 'Subscription'
    fill_in 'subscription_payment_card_number', :with => '4111111111111111'
    fill_in 'subscription_payment_card_verification', :with => '111'
    fill_in 'subscription_payment_card_billing_zip', :with => '60126'
    select('2013', :from => 'subscription_payment_card_expires_on_1i')
    select('6 - June', :from => 'subscription_payment_card_expires_on_2i')
    click_button "Submit Payment"
    find('.alert-message').should have_content('Thank you for your payment.')
      
    click_link "Browse"
    click_link "Developer B Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => '500'
    fill_in 'bid_line_item_bids_attributes_1_unit_cost', :with => '400'
    fill_in 'bid_line_item_bids_attributes_2_unit_cost', :with => '300'
    fill_in 'bid_line_item_bids_attributes_3_unit_cost', :with => '200'
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => '100'
    click_button "Publish Bid"
    find('.alert-message').should have_content('Bid was successfully created')
    end
 end