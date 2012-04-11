# == Schema Information
#
# Table name: subscription_adjustments
#
#  id                     :integer         not null, primary key
#  subscription_id        :integer         not null
#  type                   :string(255)     not null
#  start_at               :datetime
#  end_at                 :datetime
#  granted_by_id          :integer
#  order_tx_id            :integer
#  upstream_authorization :string(255)
#  amount                 :decimal(8, 2)
#  interval               :string(255)
#  ip_address             :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  card_type              :string(255)
#  card_display_number    :string(255)
#  card_billing_zip       :string(255)
#  card_expires_on        :date
#  created_at             :datetime
#  updated_at             :datetime
#

class SubscriptionAdjustment < ActiveRecord::Base
  belongs_to :subscription

  validates :start_at, :presence => true

  after_save :update_subscription_valid_until

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

  private

  def update_subscription_valid_until
    subscription.update_valid_until(self)
  end
end
