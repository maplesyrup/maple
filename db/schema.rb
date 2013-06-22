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

ActiveRecord::Schema.define(:version => 20130621205813) do

  create_table "assets", :force => true do |t|
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.boolean  "selected"
  end

  create_table "banned_companies_posts", :force => true do |t|
    t.integer "company_id", :null => false
    t.integer "post_id",    :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "starttime"
    t.datetime "endtime"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "flag"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "commenter_id"
    t.string   "commenter_type"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.string   "email",                     :default => "",                               :null => false
    t.string   "encrypted_password",        :default => "",                               :null => false
    t.string   "authentication_token"
    t.integer  "sign_in_count",             :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.string   "image",                     :default => "",                               :null => false
    t.string   "company_url",               :default => "",                               :null => false
    t.string   "blurb_title",               :default => "Company Blurb",                  :null => false
    t.string   "blurb_body",                :default => "Hey, this is our company!",      :null => false
    t.string   "more_info_title",           :default => "More Info",                      :null => false
    t.string   "more_info_body",            :default => "Here's a little more about us.", :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "splash_image_file_name"
    t.string   "splash_image_content_type"
    t.integer  "splash_image_file_size"
    t.datetime "splash_image_updated_at"
  end

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "log_entries", :force => true do |t|
    t.string   "additt_version"
    t.string   "android_build"
    t.string   "time"
    t.string   "stack_trace"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "ad_creation_log"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "company_id"
    t.integer  "campaign_id"
    t.boolean  "endorsed",           :default => false
    t.datetime "deleted_at"
  end

  create_table "posts_rewards", :id => false, :force => true do |t|
    t.integer "post_id",   :null => false
    t.integer "reward_id", :null => false
  end

  create_table "rewards", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "reward"
    t.integer  "min_votes_to_lead", :default => 0
    t.string   "requirement",       :default => "NONE"
    t.integer  "min_votes",         :default => 1
    t.integer  "quantity",          :default => 1
  end

  create_table "rewards_users", :id => false, :force => true do |t|
    t.integer "user_id",   :null => false
    t.integer "reward_id", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",                   :null => false
    t.string   "encrypted_password",     :default => "",                   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "type"
    t.text     "personal_info",          :default => "A little about me."
    t.datetime "deleted_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false, :null => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], :name => "fk_one_vote_per_user_per_entity", :unique => true
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
