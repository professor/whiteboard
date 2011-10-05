class AddVersioningToUser < ActiveRecord::Migration
  def self.up
#    Person.create_versioned_table # :table_name => 'user_verions'

    add_column :users, :version, :string

    create_table "user_versions", :force => true do |t|
      t.integer  "person_id"
      t.integer  "version"
      t.string   "webiso_account"
      t.string   "login",                     :limit => 40
      t.string   "email",                     :limit => 100
      t.string   "crypted_password",          :limit => 40
      t.string   "salt",                      :limit => 40
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "remember_token",            :limit => 40
      t.datetime "remember_token_expires_at"
      t.boolean  "is_staff",                                 :default => false
      t.boolean  "is_student",                               :default => false
      t.boolean  "is_admin",                                 :default => false
      t.string   "twiki_name"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "human_name"
      t.string   "image_uri"
      t.string   "graduation_year"
      t.string   "masters_program"
      t.string   "masters_track"
      t.boolean  "is_part_time"
      t.boolean  "is_teacher"
      t.boolean  "is_adobe_connect_host"
      t.datetime "effort_log_warning_email"
      t.boolean  "is_active"
      t.string   "legal_first_name"
      t.string   "organization_name"
      t.string   "title"
      t.string   "work_city"
      t.string   "work_state"
      t.string   "work_country"
      t.string   "telephone1"
      t.string   "skype"
      t.string   "tigris"
      t.string   "personal_email"
      t.string   "local_near_remote"
      t.text     "biography"
      t.text     "user_text"
      t.string   "office"
      t.string   "office_hours"
      t.string   "telephone1_label"
      t.string   "telephone2"
      t.string   "telephone2_label"
      t.string   "telephone3"
      t.string   "telephone3_label"
      t.string   "telephone4"
      t.string   "telephone4_label"
      t.integer  "updated_by_user_id",        :limit => 8
#      t.string   "password_salt"
#      t.string   "persistence_token",                        :default => "",    :null => false
#      t.string   "single_access_token",                      :default => "",    :null => false
#      t.integer  "login_count",                              :default => 0,     :null => false
#      t.integer  "failed_login_count",                       :default => 0,     :null => false
#      t.datetime "last_request_at"
#      t.datetime "current_login_at"
#      t.datetime "last_login_at"
#      t.string   "current_login_ip"
#      t.string   "last_login_ip"
    end


  end

  def self.down
#    Person.drop_versioned_table

    remove_column :users, :version

    drop_table :user_versions
  end
end
