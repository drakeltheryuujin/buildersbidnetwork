class AddInvitedProjectToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :invited_project
      t.index :invited_project_id
    end
  end
end
