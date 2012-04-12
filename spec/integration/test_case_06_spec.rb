require 'spec_helper'

describe 'Test Case 6 Test Viewing of Profile and Bidding on a Project' do
  fixtures:all
  it 'Gives the User Credits and a Subscription to Allow the Contractor to Bid on a Project' do
    visit '/'
    log_in_as 'user@contractori.com', 'user@contractori.com'
    page.should have_content('Dashboard')
    
    # Test Case 1 (User Fills out Invalid properties for Bid; Bid is not saved/published) 
    click_link "Browse"
    click_link "Developer E Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_cost' , :with => 'x'  
    fill_in 'bid_line_item_bids_attributes_1_unit_cost' , :with => 'x'
    fill_in 'bid_line_item_bids_attributes_2_cost' , :with => 'x'  
    fill_in 'bid_line_item_bids_attributes_3_unit_cost' , :with => 'x'
    fill_in 'bid_line_item_bids_attributes_4_cost' , :with => 'x'  
    fill_in 'bid_line_item_bids_attributes_5_unit_cost' , :with => 'x'
    fill_in 'bid_line_item_bids_attributes_6_cost' , :with => 'x'  
    fill_in 'bid_line_item_bids_attributes_7_unit_cost' , :with => 'x'
    fill_in 'bid_line_item_bids_attributes_8_cost' , :with => 'x'  
    fill_in 'bid_line_item_bids_attributes_9_unit_cost' , :with => 'x'
    click_button 'Publish Bid'
    find('.alert-message').should have_content('errors prohibited this bid from being saved:')
    
    # Test Case 2 (User Saves Bid as Draft) 
    click_link "Browse"
    click_link "Developer E Project 5"
    click_link "Enter Bid"
    fill_in 'bid_line_item_bids_attributes_0_cost' , :with => '1'  
    fill_in 'bid_line_item_bids_attributes_1_unit_cost' , :with => '2'
    fill_in 'bid_line_item_bids_attributes_2_cost' , :with => '3'  
    fill_in 'bid_line_item_bids_attributes_3_unit_cost' , :with => '4'
    fill_in 'bid_line_item_bids_attributes_4_cost' , :with => '5'  
    fill_in 'bid_line_item_bids_attributes_5_unit_cost' , :with => '6'
    fill_in 'bid_line_item_bids_attributes_6_cost' , :with => '7'  
    fill_in 'bid_line_item_bids_attributes_7_unit_cost' , :with => '8'
    fill_in 'bid_line_item_bids_attributes_8_cost' , :with => '9'  
    fill_in 'bid_line_item_bids_attributes_9_unit_cost' , :with => '10'
    click_button 'Save As Draft'
    find('.alert-message').should have_content('Bid was successfully created as Draft.')
    
    # Test Case 3 (User Cancels Bid Saved as Draft) 
    click_link "Browse"
    click_link "Developer E Project 5"
    click_link "Edit Bid"
    fill_in 'bid_line_item_bids_attributes_0_cost' , :with => '1'  
    fill_in 'bid_line_item_bids_attributes_1_unit_cost' , :with => '2'
    fill_in 'bid_line_item_bids_attributes_2_cost' , :with => '3'  
    fill_in 'bid_line_item_bids_attributes_3_unit_cost' , :with => '4'
    fill_in 'bid_line_item_bids_attributes_4_cost' , :with => '5'  
    fill_in 'bid_line_item_bids_attributes_5_unit_cost' , :with => '6'
    fill_in 'bid_line_item_bids_attributes_6_cost' , :with => '7'  
    fill_in 'bid_line_item_bids_attributes_7_unit_cost' , :with => '8'
    fill_in 'bid_line_item_bids_attributes_8_cost' , :with => '9'  
    fill_in 'bid_line_item_bids_attributes_9_unit_cost' , :with => '10'
    click_button 'Cancel Bid'

    # Test Case 4 (User Publishes Bid - from Bid Creation) 
    click_link "Browse"
    click_link "Developer E Project 5"
    click_link "Edit Bid"
    fill_in 'bid_line_item_bids_attributes_0_cost' , :with => '1'  
    fill_in 'bid_line_item_bids_attributes_1_unit_cost' , :with => '2'
    fill_in 'bid_line_item_bids_attributes_2_cost' , :with => '3'  
    fill_in 'bid_line_item_bids_attributes_3_unit_cost' , :with => '4'
    fill_in 'bid_line_item_bids_attributes_4_cost' , :with => '5'  
    fill_in 'bid_line_item_bids_attributes_5_unit_cost' , :with => '6'
    fill_in 'bid_line_item_bids_attributes_6_cost' , :with => '7'  
    fill_in 'bid_line_item_bids_attributes_7_unit_cost' , :with => '8'
    fill_in 'bid_line_item_bids_attributes_8_cost' , :with => '9'  
    fill_in 'bid_line_item_bids_attributes_9_unit_cost' , :with => '10'
    click_button 'Publish Bid'
    find('.alert-message').should have_content('Bid was successfully updated')
   
     # Test Case 5 (User Publishes Bid - from Draft) 
    click_link "My BBN"
    click_link "Developer E Project 5"
    click_link "Edit Bid"
    fill_in 'bid_line_item_bids_attributes_0_cost' , :with => '1'  
    fill_in 'bid_line_item_bids_attributes_1_unit_cost' , :with => '2'
    fill_in 'bid_line_item_bids_attributes_2_cost' , :with => '3'  
    fill_in 'bid_line_item_bids_attributes_3_unit_cost' , :with => '4'
    fill_in 'bid_line_item_bids_attributes_4_cost' , :with => '5'  
    fill_in 'bid_line_item_bids_attributes_5_unit_cost' , :with => '6'
    fill_in 'bid_line_item_bids_attributes_6_cost' , :with => '7'  
    fill_in 'bid_line_item_bids_attributes_7_unit_cost' , :with => '8'
    fill_in 'bid_line_item_bids_attributes_8_cost' , :with => '9'  
    fill_in 'bid_line_item_bids_attributes_9_unit_cost' , :with => '10'
    click_button "Publish Bid"
    find('.alert-message').should have_content('Bid was successfully updated')

    log_out
  end
end
