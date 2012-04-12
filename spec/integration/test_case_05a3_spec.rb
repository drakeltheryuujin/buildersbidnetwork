require 'spec_helper'

describe 'Test Case 5a1 Verify User is Able to Click Post a Project Button and is Directed to Post a Project Page' do
  fixtures:all
  it 'welcomes the user' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
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
    page.find('#project_location_attributes_address1').click
    fill_in 'project_estimated_budget', :with => '20000'
    page.find('#project_location_attributes_address1').click
    page.find('#credit_value_label').should have_content '1'
    fill_in 'project_location_attributes_address1', :with => '123 Anywhere Lane'
    fill_in 'project_location_attributes_address2', :with => 'Suite 2122'
    fill_in 'project_location_attributes_city', :with => 'Chicago'
    select('IL', :from => 'project_location_attributes_state')
    fill_in 'project_location_attributes_post_code', :with => '60126'
    fill_in 'project_description', :with => 'I Develop Mobile Applications, and Websites'
    within 'div.project_line_items' do
      click_link 'Add a Line Item'
      page.find('.line_item_content_field').set('LI VALUE')
    end
    find(:css, "#project_terms_of_use[value='1']").set(true)
    click_button 'Save and Continue'
    find('.alert-message').should have_content('Project was successfully created')

    log_out
  end
end
