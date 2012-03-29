require 'spec_helper'

describe 'Test Case 14 Goes through the Process of Uploading a File to your Profile Avatar  ' do
fixtures:all
  it 'logs in, edits profile, uploads new avatar' do
    visit '/'
    fill_in 'user_email', :with => 'user@developera.com'
    fill_in 'Password', :with => 'user@developera.com'
    click_button 'Login'
    page.should have_content('Dashboard')
    click_link "Profile"
    click_link 'Edit Profile'
    attach_file 'asset', File.join(Rails.root, 'spec', 'support', 'assets', 'paving.jpg')
    upload_time = Time.now
    click_button 'Upload File'
    page.should have_css('p.alert-message')
    find('p.alert-message').should have_content('Profile was successfully updated.')
    profile = User.find_by_email('user@developera.com').profile
    profile.asset_file_name.should eq('paving.jpg')
    profile.asset_updated_at.should satisfy { |w| w >= upload_time }
  end
end
