class SubscriptionAdjustment < ActiveRecord::Base
  belongs_to :subscription

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