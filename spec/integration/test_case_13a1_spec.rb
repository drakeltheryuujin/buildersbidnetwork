require 'spec_helper'

describe 'Test Case 13a1-13a4 Creating a Private Project and Viewing a Private Project to those who have access' do
fixtures:all
  it 'Creates Project and Verifies only Invited People and Project Owner Can view this project' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')

    click_link 'Post a Project'
    page.should have_content('Post a Project')
    fill_in 'project_name', :with => 'Test Private Project 1a'
    select('Demolition', :from => 'project_project_type_id')
    page.find('div.field.datetime-field > div.input-append > a.add-on.calendar').click
    page.find('#calnext').click
    click_link '21'
    page.find('div.span3 > div.field.datetime-field:nth-child(1) > div.input-append > a.add-on.calendar').click
    page.find('#calnext').click
    click_link '24'
    page.find('div.span3 > div.field.datetime-field:nth-child(2) > div.input-append > a.add-on.calendar').click
    page.find('#calnext').click
    page.find('#calnext').click
    click_link '26'
    page.find('#project_location_attributes_address1').click
    fill_in 'project_estimated_budget', :with => '20000'
    page.find('#project_location_attributes_address1').click
    page.driver.execute_script('$("#project_credit_value").val(1);') # FIXME working around intermitent failure on following
    #page.find('#credit_value_label').should have_content '1'
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
    choose('project_private_true')
    find(:css, "#project_terms_of_use[value='1']").set(true)
    click_button 'Save and Continue'
    click_link 'Continue'
    find(:css, "#project_terms_of_use[value='1']").set(true)
    click_button 'Publish Project'
    find('.alert-message').should have_content('Project was successfully updated.')
    click_link "My BBN"
    click_link "Test Private Project 1a"
    click_link "Invite Only"
    fill_in 'email_address', :with => 'user@contractori.com'
    fill_in 'message_body', :with => 'Here is a Private Project which I think might be something of interest to you. Take a look'
    click_button 'Send E-Mail'
    find('.alert-message').should have_content('User invited.')
    log_out

    visit '/'
    log_in_as 'user@contractori.com', 'user@contractori.com'
    page.should have_content('Dashboard')

    click_link "My BBN"
    click_link "Notifications"
    click_link "Invitation to bid from Developer A Profile"
    click_link "Invite Only"
    click_link "Test Private Project 1a"
    click_link "Browse"

    log_out
  end
end
