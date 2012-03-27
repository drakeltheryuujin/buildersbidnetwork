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
    
     /* Test Case 1 (User Fills out Invalid properties for Bid; Bid is not saved/published) /*
    click_link "Browse"
    click_link "Developer B Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => 'x'
    fill_in 'bid_line_item_bids_attributes_1_unit_cost', :with => 'x'
    fill_in 'bid_line_item_bids_attributes_2_unit_cost', :with => 'x'
    fill_in 'bid_line_item_bids_attributes_3_unit_cost', :with => 'x'
    fill_in 'bid_line_item_bids_attributes_4_unit_cost', :with => 'x'
    click_button "Publish Bid"
    find('.alert-message').should have_content('errors prohibited this bid from being saved:')
    
    /* Test Case 2 (User Cancels Bid) /*
    click_link "Browse"
    click_link "Developer B Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => '500'
    fill_in 'bid_line_item_bids_attributes_1_unit_cost', :with => '400'
    fill_in 'bid_line_item_bids_attributes_2_unit_cost', :with => '300'
    fill_in 'bid_line_item_bids_attributes_3_unit_cost', :with => '200'
    fill_in 'bid_line_item_bids_attributes_4_unit_cost', :with => '100'
    click_button "Cancel Bid"
    find('.alert-message').should have_content('Bid was successfully created')

     /* Test Case 3 (User Saves Bid as Draft) /*
    click_link "Browse"
    click_link "Developer B Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => '500'
    fill_in 'bid_line_item_bids_attributes_1_unit_cost', :with => '400'
    fill_in 'bid_line_item_bids_attributes_2_unit_cost', :with => '300'
    fill_in 'bid_line_item_bids_attributes_3_unit_cost', :with => '200'
    fill_in 'bid_line_item_bids_attributes_4_unit_cost', :with => '100'
    click_button "Save Bid"
    find('.alert-message').should have_content('Bid was successfully created as Draft.')

     /* Test Case 4 (User Publishes Bid - from Bid Creation) /*
    click_link "Browse"
    click_link "Developer B Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => '500'
    fill_in 'bid_line_item_bids_attributes_1_unit_cost', :with => '400'
    fill_in 'bid_line_item_bids_attributes_2_unit_cost', :with => '300'
    fill_in 'bid_line_item_bids_attributes_3_unit_cost', :with => '200'
    fill_in 'bid_line_item_bids_attributes_4_unit_cost', :with => '100'
    click_button "Publish Bid"
    find('.alert-message').should have_content('Bid was successfully created')
   
     /* Test Case 5 (User Publishes Bid - from Draft) /*
    click_link "Browse"
    click_link "Developer B Project 5"
    click_link "Edit Bid"
    fill_in 'bid_line_item_bids_attributes_0_unit_cost', :with => '500'
    fill_in 'bid_line_item_bids_attributes_1_unit_cost', :with => '400'
    fill_in 'bid_line_item_bids_attributes_2_unit_cost', :with => '300'
    fill_in 'bid_line_item_bids_attributes_3_unit_cost', :with => '200'
    fill_in 'bid_line_item_bids_attributes_4_unit_cost', :with => '100'
    click_button "Publish Bid"
    end
 end