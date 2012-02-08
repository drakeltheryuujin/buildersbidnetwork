class Subscription < ActiveRecord::Base
  belongs_to :user

  has_many :subscription_adjustments

  accepts_nested_attributes_for :subscription_adjustments

  def purchase!
    return self.subscription_adjustments.first.purchase!(self)
  end

  def current?
    return self.valid_until >= Time.now
  end
end
