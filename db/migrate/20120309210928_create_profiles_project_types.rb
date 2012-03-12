class CreateProfilesProjectTypes < ActiveRecord::Migration
  def change
    create_table :profiles_project_types, :id => false do |t|
      t.integer :profile_id
      t.integer :project_type_id
    end
    add_index :profiles_project_types, :profile_id
    add_index :profiles_project_types, :project_type_id
  end
end
