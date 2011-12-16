class BidPurchaseRefundCredit < CreditAdjustmentCredit
  belongs_to :bid

  validates :bid, :presence => true
  validates_associated :bid
  validate :attrs_in_sync

  private

  def attrs_in_sync
    self.errors[:base] << "Out of sync purchase." unless self.value == self.bid.project.credit_value
  end
end
