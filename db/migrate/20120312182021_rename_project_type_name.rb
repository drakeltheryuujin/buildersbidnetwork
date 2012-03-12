class RenameProjectTypeName < ActiveRecord::Migration
  def up
    rename_column :project_types, :name, :type_name
  end

  def down
    rename_column :project_types, :type_name, :name
  end
end
