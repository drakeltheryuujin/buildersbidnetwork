class FixLocationPostCodeColumn < ActiveRecord::Migration
  def change
    rename_column :locations, :postCode, :post_code
  end
end
