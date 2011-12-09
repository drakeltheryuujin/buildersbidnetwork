class ChangeProjectEstimatedBudgetPrecision < ActiveRecord::Migration
  def up
    change_column :projects, :estimated_budget, :decimal, { :scale => 2, :precision => 11 }
  end

  def down
    change_column :projects, :estimated_budget, :decimal, { :scale => 2, :precision => 8 }
  end
end
