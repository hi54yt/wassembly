# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100217194906) do

  create_table "announcements", :force => true do |t|
    t.text     "message",    :null => false
    t.datetime "starts_at",  :null => false
    t.datetime "ends_at",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "proposition_id",                :null => false
    t.text     "body",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "interest",       :default => 0, :null => false
    t.string   "ip",                            :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title",      :null => false
    t.string   "permalink",  :null => false
    t.text     "content",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"

  create_table "propositions", :force => true do |t|
    t.string   "title",                                      :null => false
    t.text     "body",                                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                    :null => false
    t.string   "state",                                      :null => false
    t.text     "summary",                                    :null => false
    t.integer  "interest",                    :default => 0, :null => false
    t.integer  "yes_count",                   :default => 0, :null => false
    t.integer  "no_count",                    :default => 0, :null => false
    t.integer  "senators_yes_count",          :default => 0, :null => false
    t.integer  "senators_no_count",           :default => 0, :null => false
    t.string   "ip",                                         :null => false
    t.integer  "comments_count",              :default => 0, :null => false
    t.integer  "identity_verified_yes_count", :default => 0
    t.integer  "identity_verified_no_count",  :default => 0
    t.datetime "end_voting_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "value",             :default => 0
    t.integer  "rateable_owner_id",                :null => false
    t.integer  "rater_id",                         :null => false
    t.integer  "rateable_id",                      :null => false
    t.string   "rateable_type",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip",                               :null => false
    t.float    "affinity",                         :null => false
  end

  add_index "ratings", ["rateable_id", "rateable_type"], :name => "fk_rateables"
  add_index "ratings", ["rater_id", "rateable_id", "rateable_type"], :name => "uniq_one_rating_only", :unique => true
  add_index "ratings", ["rater_id"], :name => "fk_raters"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                                 :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",             :default => false, :null => false
    t.string   "perishable_token"
    t.string   "role",                                  :null => false
    t.integer  "karma",              :default => 0,     :null => false
    t.string   "openid_identifier"
    t.boolean  "senator",            :default => false, :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "show_real_name",     :default => true,  :null => false
    t.string   "encrypted_eid"
    t.boolean  "identity_verified",  :default => false, :null => false
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id",                                   :null => false
    t.integer  "proposition_id",                            :null => false
    t.boolean  "agree",                  :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "from_senator",           :default => false, :null => false
    t.string   "ip",                                        :null => false
    t.boolean  "from_identity_verified", :default => false
  end

end
