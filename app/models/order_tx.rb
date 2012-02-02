# == Schema Information
#
# Table name: order_txes
#
#  id                :integer         not null, primary key
#  payment_credit_id :integer
#  action            :string(255)
#  amount            :integer
#  success           :boolean
#  authorization     :string(255)
#  message           :string(255)
#  params            :text
#  created_at        :datetime
#  updated_at        :datetime
#
class OrderTx < ActiveRecord::Base
	belongs_to :payment_credit
  serialize :params
  
  def response=(response)
    self.success       = response.success?
    self.authorization = response.authorization
    self.message       = response.message
    self.params        = response.params
  rescue ActiveMerchant::ActiveMerchantError => e
    self.success       = false
    self.authorization = nil
    self.message       = e.message
    self.params        = {}
  end
end
