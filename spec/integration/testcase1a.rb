require 'spec_helper'

describe 'Test Case 1a  Navigates to Home Page' do
  it 'And then tests all the links and then verifies it is pointing to the correct places' do
    visit '/'
    click_link "Terms of Use"
    page.should have_content('User Agreement')
    click_link "Privacy Policy"
    page.should have_content('Privacy Policy')
    click_link "About"
    page.should have_content('About Us')
    click_link "FAQs"
    page.should have_content('Questions About My Account')
    click_link "Contact Us"
    page.should have_content('contact@buildersbidnetwork.com')
    click_link "Advertise"
    page.should have_content('E-mail us if you are interested in advertising on our site!')
    click_link "How"
    page.should have_content('How It Works')
    click_link "Browse"
    page.should have_content('Browse Projects')
  end
end