# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Add this to load Capybara integration:
require 'capybara/rspec'
require 'capybara/rails'

require 'capybara/email/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

module Geocoder::Store
  module ActiveRecord
    def geocode
      fetch_coordinates if $TEST_GEOCODING
    end
  end
end

shared_examples_for "presence of" do |property|
  it "requires a value for #{property}" do
    record = new_valid_record
    record.send(:"#{property}=", nil)
    record.should_not be_valid
    record.errors[property.to_sym].should include("can't be blank")
  end
end

RSpec.configure do |config|
  Capybara.default_driver = :selenium
  Capybara.server_port = 3001

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/test/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.alias_it_should_behave_like_to :it_validates, "a model that validates"
end
