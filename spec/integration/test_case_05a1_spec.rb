require 'spec_helper'

describe 'Test Case 5a1 Verify User is Able to Click Post a Project Button and is Directed to Post a Project Page' do
  fixtures:all
  it 'welcomes the user' do
    visit '/'
    log_in_as 'user@developera.com', 'user@developera.com'
    page.should have_content('Dashboard')

    click_link 'Post a Project'
    page.should have_content('Post a Project')

    log_out
  end
end
