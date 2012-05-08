class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, :null => true
      t.string :provider, :null => false
      t.string :uid, :null => false
      t.string :token
      t.string :secret
      t.string :avatar_url
      t.string :name
      t.string :profile_url

      t.timestamps
    end
    add_index :authentications, :user_id
  end
end
