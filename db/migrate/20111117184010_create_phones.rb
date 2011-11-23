class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number
      t.references :phone_type

      t.timestamps
    end
    add_index :phones, :phone_type_id
  end
end
