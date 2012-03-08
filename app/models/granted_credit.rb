class GrantedCredit < CreditAdjustmentCredit
  belongs_to :granted_by, :class_name => "User"

  validates :granted_by, :presence => true, :if => :not_deleted?
  validate :granted_by_admin, :if => :not_deleted?

  private
  def granted_by_admin
    unless self.granted_by.present? && self.granted_by.admin
      errors[:base] << "Only Admin can grant credits"
    end
  end
end
