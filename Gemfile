source 'http://rubygems.org'

#gem 'rails', '3.0.9'
gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# core
gem 'sqlite3'
# mysql
#gem 'mysql2' #, '< 0.3'
# postgress
gem 'pg'

# users & authentication
gem 'devise'
gem 'devise_invitable'

# jquery
gem 'jquery-rails', '>= 1.0.12'

# model documentation
gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'

# validates dates before/after/between.
gem 'date_validator'
# validates urls
gem 'validates_url_format_of'

# support for dynamically adding model children through form
gem 'nested_form', :git => "git://github.com/ryanb/nested_form.git"

# inbox and notifications
gem 'mailboxer', '~> 0.5.4'

# pagination
gem 'kaminari'

# attach images and documents to model
gem 'paperclip'
gem 'aws-s3'

# clear credit card transactions
gem 'activemerchant'

# traslate addresses to lat/long, perform nearby queries
gem 'geocoder'

# full text indexes and searching for postgres
gem 'texticle', '~> 2.0', :require => 'texticle/rails'

# twitter bootstrap 
#gem 'twitter-bootstrap-rails'
#gem 'less-rails-bootstrap'
gem "css-bootstrap-rails"

# ActiveAdmin http://activeadmin.info/
gem 'activeadmin'
gem 'sass-rails'
gem "meta_search",    '>= 1.1.0.pre'

# state machine
gem "aasm"

# soft delete
gem "permanent_records"

# linked in
gem "omniauth"
gem "omniauth-linkedin"
gem "linkedin"

# production
gem "heroku"
gem 'exception_notification'
gem 'rack-rewrite'
gem 'newrelic_rpm'

group :development do
# model diagrams
  gem "rails-erd"
# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'
# gem 'ruby-debug-ide'
end
group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-email'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'


# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
