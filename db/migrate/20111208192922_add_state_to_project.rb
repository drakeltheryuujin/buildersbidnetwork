class AddStateToProject < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.string :state
      t.index :state
      t.decimal :estimated_budget, :precision => 8, :scale => 2
      t.integer :credit_value
    end
  end
end
