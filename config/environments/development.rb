Ypn::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

#  config.action_mailer.smtp_settings = {
#    :address              => "mail.htmlfive.org",
#    :port                 => 25,
#    :domain               => "htmlfive.org",
#    :user_name            => "ypn@htmlfive.org",
#    :password             => "developer8",
#    :authentication       => "plain",
#    :enable_starttls_auto => true,
#    :openssl_verify_mode => 'none'
#  }
  PAPERCLIP_STORAGE_OPTIONS = {}
#  PAPERCLIP_STORAGE_OPTIONS = {
#    :storage => :s3,
#    :s3_credentials => "#{Rails.root}/config/s3.yml",
#    :bucket => 'project-document-bucket'
#  }

	config.after_initialize do
    LOGIN_ID = '2n4C4Heq'
		TRANSACTION_KEY = '6D46P5gn46tak4Qs' 
	  ActiveMerchant::Billing::Base.mode = :test
	  ::GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(
	    :login  => LOGIN_ID,
	    :password => TRANSACTION_KEY
    )
	end
end
