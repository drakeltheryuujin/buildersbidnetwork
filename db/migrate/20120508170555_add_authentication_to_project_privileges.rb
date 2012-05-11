class AddAuthenticationToProjectPrivileges < ActiveRecord::Migration
  def change
    change_table :project_privileges do |t|
      t.references :authentication
    end
    add_index :project_privileges, :authentication_id
  end
end
