Mailboxer.setup do |config|
  
  #Configures if you applications uses or no the email sending for Notifications and Messages
  config.uses_emails = true
  
  #Configures the default from for the email sent for Messages and Notifications of Mailboxer
  config.default_from = "no-reply@ypn.heroku.com"
  
  config.email_method = :mailboxer_email
  config.name_method = :mailboxer_name
end