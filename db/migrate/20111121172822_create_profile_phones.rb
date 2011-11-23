class CreateProfilePhones < ActiveRecord::Migration
  def change
    create_table :profile_phones do |t|
      t.references :profile
      t.references :phone

      t.timestamps
    end
    add_index :profile_phones, :profile_id
    add_index :profile_phones, :phone_id
  end
end
