require 'active_merchant'

# MOST BASIC EXAMPLE 

# random amount from $10 to $35 - this prevents duplicate transaction errors
charge_amount = rand(1000)+2500 

LOGIN_ID = '2n4C4Heq'
TRANSACTION_KEY = '6D46P5gn46tak4Qs'
ActiveMerchant::Billing::Base.mode = :test 

#number = '4222222222222' #Authorize.net test card, error-producing
number = '4007000000027' #Authorize.net test card, non-error-producing

credit_card = ActiveMerchant::Billing::CreditCard.new(
  :number => number,
  :month => 12,
  :year => 2011,
  :first_name => 'Tobias',
  :last_name => 'Luetke',
  :type => 'visa',
  :verification_value => '123'
)

if credit_card.valid?
  gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
   :login  => LOGIN_ID,
   :password => TRANSACTION_KEY
  )
  response = gateway.purchase(charge_amount, credit_card)

  if response.success?
    #puts "success!"
    puts "Success: " + response.message.to_s
  else
   raise StandardError.new( response.message )
  end
else
  puts "Credit card not valid: #{credit_card.errors.full_messages.join('. ')}."
end

# EXAMPLE USING BILLING ADDRESS

# random amount from $10 to $35 - this prevents duplicate transaction errors
#charge_amount = rand(1000)+2500
#number = '4222222222222' #Authorize.net test card, error-producing
##number = '4007000000027' #Authorize.net test card, non-error-producing
#billing_address = { :name => 'Mark McBride', :address1 => '1 Show Me The Money Lane', :city => 'San Francisco', :state => 'CA', :country => 'US', :zip => '23456', :phone => '(555)555-5555' }
#
#creditcard = ActiveMerchant::Billing::CreditCard.new(
# :number => number,
# :month => 3,        #for test cards, use any date in the future
# :year => 2010,
# :first_name => 'Mark',
# :last_name => 'McBride',
# :type => 'visa'       #note that MasterCard is 'master'
#)
#
#if creditcard.valid?
#  gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
#   :login  => LOGIN_ID,
#   :password => TRANSACTION_KEY)
#
#  options = {:address => {}, :billing_address => billing_address}
#
#  response = gateway.authorize(charge_amount, creditcard, options)
#
#  if response.success?
#    gateway.capture(charge_amount, response.authorization)
#    puts "Success: " + response.message.to_s
#  else
#    puts "Fail: " + response.message.to_s
#  end
#else
#  puts "Credit card not valid: " + creditcard.validate.to_s
#end
