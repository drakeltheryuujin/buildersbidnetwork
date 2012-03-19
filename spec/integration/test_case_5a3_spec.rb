require 'spec_helper'

describe 'Test Case 5a1 Verify User is Able to Click Post a Project Button and is Directed to Post a Project Page' do
fixtures:all
  it 'welcomes the user' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    find_field('user_email').value.should == 'user@developera.com' 
    fill_in 'Password', :with => 'user@developera.com'
    find_field('Password').value.should == 'user@developera.com' 
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link 'Post a Project'
    page.should have_content('Post a Project')
    fill_in 'project_name', :with => 'Test Project 1a'
    select('Demolition', :from => 'project_project_type_id')
    page.find('div.span3 > div.field.datetime-field > div.input-append > a.add-on.calendar').click
    page.find('#calnext').click
    page.find('div.span3 > div.field.datetime-field:nth-child(1) > div.input-append > a.add-on.calendar').click
    page.find('#calnext').click
    page.find('div.span3 > div.field.datetime-field:nth-child(2) > div.input-append > a.add-on.calendar').click
    page.find('#calnext').click
    fill_in 'project_estimated_budget', :with => '20000'
    fill_in 'project_location_attributes_address1', :with => '123 Anywhere Lane'
    fill_in 'project_location_attributes_address2', :with => 'Suite 2122'
    fill_in 'project_location_attributes_city', :with => 'Chicago'
    select('IL', :from => 'project_location_attributes_state')
    fill_in 'project_location_attributes_post_code', :with => '60126'
    fill_in 'project_description', :with => 'I Develop Mobile Applications, and Websites'
    find(:css, "#project_terms_of_use[value='1']").set(true)
    click_button 'Save and Continue'
    assert_equal 'Test Project 1a', 'Test Project 1a' 
    assert_equal '123 Anywhere Lane', '123 Anywhere Lane'
    assert_equal 'Suite 2122', 'Suite 2122'
    assert_equal 'Chicago' , 'Chicago'
    assert_equal 'Illinois', 'Illinois'
    assert_equal '60126', '60126'
    assert_equal 'I Develop Mobile Applications, and Websites', 'I Develop Mobile Applications, and Websites'  
    find('.alert-message').should have_content('Project was successfully created')
    end
 end