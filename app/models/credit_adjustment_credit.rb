# == Schema Information
#
# Table name: credit_adjustments
#
#  id               :integer         not null, primary key
#  value            :integer
#  type             :string(255)     not null
#  user_id          :integer         not null
#  order_tx_id      :integer
#  ip_address       :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  card_type        :string(255)
#  card_expires_on  :date
#  bid_id           :integer
#  project_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#  card_billing_zip :string(255)
#

# == Schema Information
#
# Table name: credit_adjustments
#
#  id               :integer         not null, primary key
#  value            :integer
#  type             :string(255)     not null
#  user_id          :integer         not null
#  order_tx_id      :integer
#  ip_address       :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  card_type        :string(255)
#  card_expires_on  :date
#  bid_id           :integer
#  project_id       :integer
#  created_at       :datetime
#  updated_at       :datetime
#  card_billing_zip :string(255)
#
class CreditAdjustmentCredit < CreditAdjustment
  validates_numericality_of :value, :only_integer =>true, :greater_than => 0
end
