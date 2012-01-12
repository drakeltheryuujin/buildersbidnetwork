# Load the rails application
require File.expand_path('../application', __FILE__)

require 'active_record_fk_hack'

Date::DATE_FORMATS[:tiny] = "%b %d"
Date::DATE_FORMATS[:short] = "%m/%d/%y"
Date::DATE_FORMATS[:med] = "%b %-d %Y"
Time::DATE_FORMATS[:tiny] = "%b %d %-l:%M %p"
Time::DATE_FORMATS[:short] = "%m/%d/%y %-l:%M %p"
Time::DATE_FORMATS[:med] = "%b %-d %Y, %-l:%M %P"

# Initialize the rails application
Ypn::Application.initialize!
