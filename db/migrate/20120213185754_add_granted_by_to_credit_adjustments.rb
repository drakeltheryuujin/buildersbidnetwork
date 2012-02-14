class AddGrantedByToCreditAdjustments < ActiveRecord::Migration
  def change
    add_column :credit_adjustments, :granted_by_id, :integer
  end
end
