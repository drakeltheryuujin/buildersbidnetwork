ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module Geocoder::Store
  module ActiveRecord
    def geocode
      fetch_coordinates if $TEST_GEOCODING
    end
  end
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  def assert_valid(object)
    assert(object.valid?)
  end

  def assert_invalid(object)
    assert(!object.valid?)
  end

  def assert_field_invalid(object, field)
    assert_invalid(object)
    assert(object.errors[field], "Expected an error on validation")
  end

  # Add more helper methods to be used by all tests here...
  def assert_presence_required(object, field)
    # Test that the initial object is valid
    assert_valid(object)
    
    # Test that it becomes invalid by removing the field
    temp = object.send(field)
    object.send("#{field}=", nil)
    assert_field_invalid(object, field)
    
    # Make object valid again
    object.send("#{field}=", temp)
  end
end
