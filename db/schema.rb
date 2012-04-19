# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120419195138) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "bids", :force => true do |t|
    t.decimal  "total",      :precision => 10, :scale => 2
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                     :default => "draft"
    t.datetime "deleted_at"
  end

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.datetime "deleted_at"
  end

  create_table "credit_adjustments", :force => true do |t|
    t.integer  "value"
    t.string   "type",                                              :null => false
    t.integer  "user_id",                                           :null => false
    t.integer  "order_tx_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.integer  "bid_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_billing_zip"
    t.decimal  "amount",              :precision => 8, :scale => 2
    t.string   "card_display_number"
    t.integer  "granted_by_id"
    t.datetime "deleted_at"
  end

  add_index "credit_adjustments", ["bid_id"], :name => "index_credit_adjustments_on_bid_id"
  add_index "credit_adjustments", ["project_id"], :name => "index_credit_adjustments_on_project_id"
  add_index "credit_adjustments", ["user_id"], :name => "index_credit_adjustments_on_user_id"

  create_table "line_item_bids", :force => true do |t|
    t.decimal  "unit_cost",    :precision => 10, :scale => 2
    t.decimal  "cost",         :precision => 10, :scale => 2
    t.integer  "bid_id"
    t.integer  "line_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "line_items", :force => true do |t|
    t.string   "content"
    t.integer  "units"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "post_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_type"
    t.datetime "deleted_at"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "order_txes", :force => true do |t|
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "phone_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.string   "number"
    t.integer  "phone_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phones", ["phone_type_id"], :name => "index_phones_on_phone_type_id"

  create_table "profile_documents", :force => true do |t|
    t.string   "description"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "profile_documents", ["profile_id"], :name => "index_profile_documents_on_profile_id"

  create_table "profile_phones", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "phone_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "profile_phones", ["phone_id"], :name => "index_profile_phones_on_phone_id"
  add_index "profile_phones", ["profile_id"], :name => "index_profile_phones_on_profile_id"

  create_table "profiles", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "type"
    t.integer  "location_id",                           :null => false
    t.string   "established"
    t.text     "description"
    t.string   "website"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.boolean  "hidden",             :default => false
    t.datetime "deleted_at"
  end

  create_table "profiles_project_types", :id => false, :force => true do |t|
    t.integer "profile_id"
    t.integer "project_type_id"
  end

  add_index "profiles_project_types", ["profile_id"], :name => "index_profiles_project_types_on_profile_id"
  add_index "profiles_project_types", ["project_type_id"], :name => "index_profiles_project_types_on_project_type_id"

  create_table "project_documents", :force => true do |t|
    t.string   "description"
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "project_documents", ["project_id"], :name => "index_project_documents_on_project_id"

  create_table "project_privileges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "project_privileges", ["project_id"], :name => "index_project_privileges_on_project_id"
  add_index "project_privileges", ["user_id"], :name => "index_project_privileges_on_user_id"

  create_table "project_types", :force => true do |t|
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name",                                                               :null => false
    t.integer  "user_id",                                                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "bidding_end",                                                        :null => false
    t.datetime "pre_bid_meeting"
    t.date     "project_start",                                                      :null => false
    t.date     "project_end",                                                        :null => false
    t.text     "description",                                                        :null => false
    t.text     "notes"
    t.integer  "location_id",                                                        :null => false
    t.integer  "project_type_id",                                                    :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "state"
    t.decimal  "estimated_budget", :precision => 11, :scale => 2
    t.integer  "credit_value"
    t.integer  "cover_photo_id"
    t.boolean  "private",                                         :default => false
    t.datetime "deleted_at"
  end

  add_index "projects", ["state"], :name => "index_projects_on_state"

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "read",                          :default => false
    t.boolean  "trashed",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.datetime "deleted_at"
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "subscription_adjustments", :force => true do |t|
    t.integer  "subscription_id",                                      :null => false
    t.string   "type",                                                 :null => false
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "granted_by_id"
    t.integer  "order_tx_id"
    t.string   "upstream_authorization"
    t.decimal  "amount",                 :precision => 8, :scale => 2
    t.string   "interval"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.string   "card_display_number"
    t.string   "card_billing_zip"
    t.date     "card_expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "upstream_authorization"
    t.datetime "valid_until"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                       :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credits"
    t.boolean  "admin",                                 :default => false
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invited_project_id"
    t.datetime "deleted_at"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["invited_project_id"], :name => "index_users_on_invited_project_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  add_foreign_key "notifications", "conversations", :name => "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", :name => "receipts_on_notification_id"

end
