class AddDetailsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :established, :string
    add_column :profiles, :description, :text
    add_column :profiles, :website, :string
  end
end
