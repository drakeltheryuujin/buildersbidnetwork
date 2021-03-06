# == Schema Information
#
# Table name: credit_adjustments
#
#  id                  :integer         not null, primary key
#  value               :integer
#  type                :string(255)     not null
#  user_id             :integer         not null
#  order_tx_id         :integer
#  ip_address          :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  card_type           :string(255)
#  card_expires_on     :date
#  bid_id              :integer
#  project_id          :integer
#  created_at          :datetime
#  updated_at          :datetime
#  card_billing_zip    :string(255)
#  amount              :decimal(8, 2)
#  card_display_number :string(255)
#  granted_by_id       :integer
#

class CreditAdjustment < ActiveRecord::Base
  belongs_to :user

  validates :user, :presence => true

  after_save :update_user_credits
  def update_user_credits
    self.user.update_attribute(:credits, self.user.credit_adjustments.not_deleted.sum(:value)) 
  end

  scope :payment, where(:type => "PaymentCredit")

  class << self
    def new(attributes = {}, options = {}, &block)
      adjustment_type = attributes.delete(:adjustment_type)
      return super if adjustment_type.blank?

      klass_name = "#{adjustment_type.to_s.camelize}"
      if Object.const_defined?(klass_name)
        klass = Object.const_get(klass_name)
      else
        begin
          klass = Object.const_missing(klass_name)
        rescue NameError => e
          if e.instance_of?(NameError)
            raise ArgumentError, "Unknown adjustment type: #{adjustment_type}"
          else
            raise e
          end
        end
      end

      klass.new(attributes, options, &block)
    end
  end
end
