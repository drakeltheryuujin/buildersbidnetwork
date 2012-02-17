class CreateProjectPrivileges < ActiveRecord::Migration
  def change
    create_table :project_privileges do |t|
      t.references :user
      t.references :project

      t.timestamps
    end
    add_index :project_privileges, :user_id
    add_index :project_privileges, :project_id
  end
end
