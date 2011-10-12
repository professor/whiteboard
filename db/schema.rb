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

ActiveRecord::Schema.define(:version => 20111012001924) do

  create_table "course_numbers", :force => true do |t|
    t.string   "name"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name"
  end

  create_table "courses", :force => true do |t|
    t.integer  "course_number_id"
    t.string   "name"
    t.string   "number"
    t.string   "semester"
    t.string   "mini"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "primary_faculty_label"
    t.string   "secondary_faculty_label"
    t.string   "twiki_url"
    t.boolean  "remind_about_effort"
    t.string   "short_name"
    t.integer  "year"
    t.boolean  "configure_class_mailinglist",     :default => false
    t.date     "peer_evaluation_first_email"
    t.date     "peer_evaluation_second_email"
    t.boolean  "configure_teams_name_themselves", :default => true
    t.string   "curriculum_url"
    t.boolean  "configure_course_twiki",          :default => false
    t.boolean  "is_configured",                   :default => false
    t.integer  "updated_by_user_id"
    t.integer  "configured_by_user_id"
  end

  add_index "courses", ["mini"], :name => "index_courses_on_mini"
  add_index "courses", ["number"], :name => "index_courses_on_number"
  add_index "courses", ["semester"], :name => "index_courses_on_semester"
  add_index "courses", ["twiki_url"], :name => "index_courses_on_twiki_url"
  add_index "courses", ["year"], :name => "index_courses_on_year"

  create_table "courses_people", :id => false, :force => true do |t|
    t.integer  "course_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses_people", ["course_id", "person_id"], :name => "index_courses_people_on_course_id_and_person_id", :unique => true

  create_table "curriculum_comment_types", :force => true do |t|
    t.string   "name"
    t.string   "background_color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curriculum_comments", :force => true do |t|
    t.string   "url"
    t.string   "semester"
    t.string   "year"
    t.integer  "user_id"
    t.integer  "curriculum_comment_type_id"
    t.string   "comment",                    :limit => 4000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "human_name"
    t.boolean  "notify_me"
  end

  add_index "curriculum_comments", ["semester"], :name => "index_curriculum_comments_on_semester"
  add_index "curriculum_comments", ["url"], :name => "index_curriculum_comments_on_url"
  add_index "curriculum_comments", ["year"], :name => "index_curriculum_comments_on_year"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deliverable_attachment_versions", :force => true do |t|
    t.integer  "deliverable_id"
    t.integer  "submitter_id"
    t.datetime "submission_date"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.text     "comment"
  end

  create_table "deliverables", :force => true do |t|
    t.text     "name"
    t.integer  "team_id"
    t.integer  "course_id"
    t.string   "task_number"
    t.integer  "is_team_deliverable"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "feedback_comment"
    t.string   "feedback_file_name"
    t.string   "feedback_content_type"
    t.integer  "feedback_file_size"
    t.datetime "feedback_updated_at"
  end

  create_table "effort_log_line_items", :force => true do |t|
    t.integer  "effort_log_id"
    t.integer  "course_id"
    t.integer  "task_type_id"
    t.float    "day1"
    t.float    "day2"
    t.float    "day3"
    t.float    "day4"
    t.float    "day5"
    t.float    "day6"
    t.float    "day7"
    t.float    "sum"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "position"
  end

  add_index "effort_log_line_items", ["effort_log_id"], :name => "index_effort_log_line_items_on_effort_log_id"

  create_table "effort_logs", :force => true do |t|
    t.integer  "person_id"
    t.integer  "week_number"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "sum"
  end

  add_index "effort_logs", ["person_id"], :name => "index_effort_logs_on_person_id"
  add_index "effort_logs", ["week_number"], :name => "index_effort_logs_on_week_number"

  create_table "pages", :force => true do |t|
    t.integer  "course_id"
    t.string   "title"
    t.integer  "position"
    t.integer  "indentation_level"
    t.boolean  "is_task"
    t.text     "tab_one_contents"
    t.text     "tab_two_contents"
    t.text     "tab_three_contents"
    t.integer  "task_duration"
    t.string   "tab_one_email_from"
    t.string   "tab_one_email_subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "tips_and_traps"
    t.text     "readings_and_resources"
    t.text     "faculty_notes"
    t.integer  "updated_by_user_id"
    t.integer  "version"
    t.string   "version_comments"
    t.string   "url"
    t.boolean  "is_editable_by_all",     :default => false
    t.boolean  "is_duplicated_page",     :default => false
  end

  add_index "pages", ["course_id"], :name => "index_pages_on_course_id"
  add_index "pages", ["position"], :name => "index_pages_on_position"
  add_index "pages", ["url"], :name => "index_pages_on_url"

  create_table "peer_evaluation_learning_objectives", :force => true do |t|
    t.integer  "person_id"
    t.integer  "team_id"
    t.string   "learning_objective"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "peer_evaluation_learning_objectives", ["person_id"], :name => "index_peer_evaluation_learning_objectives_on_person_id"
  add_index "peer_evaluation_learning_objectives", ["team_id"], :name => "index_peer_evaluation_learning_objectives_on_team_id"

  create_table "peer_evaluation_reports", :force => true do |t|
    t.integer  "team_id"
    t.integer  "recipient_id"
    t.text     "feedback"
    t.datetime "email_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "peer_evaluation_reports", ["recipient_id"], :name => "index_peer_evaluation_reports_on_recipient_id"
  add_index "peer_evaluation_reports", ["team_id"], :name => "index_peer_evaluation_reports_on_team_id"

  create_table "peer_evaluation_reviews", :force => true do |t|
    t.integer  "team_id"
    t.integer  "author_id"
    t.integer  "recipient_id"
    t.string   "question"
    t.text     "answer"
    t.integer  "sequence_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "peer_evaluation_reviews", ["author_id"], :name => "index_peer_evaluation_reviews_on_author_id"
  add_index "peer_evaluation_reviews", ["recipient_id"], :name => "index_peer_evaluation_reviews_on_recipient_id"
  add_index "peer_evaluation_reviews", ["team_id"], :name => "index_peer_evaluation_reviews_on_team_id"

  create_table "project_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_types", ["name"], :name => "index_project_types_on_name"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "project_type_id"
    t.integer  "course_id"
    t.boolean  "is_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["name"], :name => "index_projects_on_name"

  create_table "rss_feeds", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "publication_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scotty_dog_sayings", :force => true do |t|
    t.text     "saying"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scotty_dog_sayings", ["user_id"], :name => "index_scotty_dog_sayings_on_user_id"

  create_table "sponsored_project_allocations", :force => true do |t|
    t.integer  "sponsored_project_id"
    t.integer  "person_id"
    t.integer  "current_allocation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_archived",          :default => false
  end

  add_index "sponsored_project_allocations", ["is_archived"], :name => "index_sponsored_project_allocation_on_is_archived"
  add_index "sponsored_project_allocations", ["person_id"], :name => "index_sponsored_project_allocation_on_person_id"
  add_index "sponsored_project_allocations", ["sponsored_project_id"], :name => "index_sponsored_project_allocation_on_sponsored_project_id"

  create_table "sponsored_project_efforts", :force => true do |t|
    t.integer  "sponsored_project_allocation_id"
    t.integer  "year"
    t.integer  "month"
    t.integer  "actual_allocation"
    t.integer  "current_allocation"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sponsored_project_efforts", ["month"], :name => "index_sponsored_project_efforts_on_month"
  add_index "sponsored_project_efforts", ["sponsored_project_allocation_id"], :name => "index_sponsored_project_efforts_on_sponsored_projects_people_id"
  add_index "sponsored_project_efforts", ["year"], :name => "index_sponsored_project_efforts_on_year"

  create_table "sponsored_project_sponsors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_archived", :default => false
  end

  add_index "sponsored_project_sponsors", ["is_archived"], :name => "index_sponsored_project_sponsors_on_is_archived"
  add_index "sponsored_project_sponsors", ["name"], :name => "index_sponsored_project_sponsors_on_name"

  create_table "sponsored_projects", :force => true do |t|
    t.string   "name"
    t.integer  "sponsor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_archived", :default => false
  end

  add_index "sponsored_projects", ["is_archived"], :name => "index_sponsored_projects_on_is_archived"
  add_index "sponsored_projects", ["name"], :name => "index_sponsored_projects_on_name"
  add_index "sponsored_projects", ["sponsor_id"], :name => "index_sponsored_projects_on_sponsor_id"

  create_table "strength_themes", :force => true do |t|
    t.string   "theme"
    t.string   "brief_description"
    t.text     "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestions", :force => true do |t|
    t.integer  "user_id"
    t.text     "comment"
    t.string   "page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  add_index "suggestions", ["user_id"], :name => "index_suggestions_on_user_id"

  create_table "task_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "is_staff",    :default => false
    t.boolean  "is_student",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "twiki_space"
    t.string   "tigris_space"
    t.integer  "primary_faculty_id"
    t.integer  "secondary_faculty_id"
    t.string   "livemeeting"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "section"
    t.date     "peer_evaluation_first_email"
    t.date     "peer_evaluation_second_email"
    t.boolean  "peer_evaluation_do_point_allocation"
    t.integer  "course_id"
    t.boolean  "updating_email"
  end

  add_index "teams", ["course_id"], :name => "index_teams_on_course_id"

  create_table "teams_people", :id => false, :force => true do |t|
    t.integer "team_id"
    t.integer "person_id"
  end

  add_index "teams_people", ["person_id"], :name => "index_teams_people_on_person_id"
  add_index "teams_people", ["team_id"], :name => "index_teams_people_on_team_id"

  create_table "user_versions", :force => true do |t|
    t.integer  "person_id"
    t.integer  "version"
    t.string   "webiso_account"
    t.string   "login",                                 :limit => 40
    t.string   "email",                                 :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_staff",                                             :default => false
    t.boolean  "is_student",                                           :default => false
    t.boolean  "is_admin",                                             :default => false
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
    t.integer  "updated_by_user_id",                    :limit => 8
    t.boolean  "is_alumnus"
    t.string   "pronunciation"
    t.datetime "google_created"
    t.datetime "twiki_created"
    t.datetime "adobe_created"
    t.datetime "msdnaa_created"
    t.integer  "sign_in_count_old",                                    :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "yammer_created"
    t.integer  "strength1_id"
    t.integer  "strength2_id"
    t.integer  "strength3_id"
    t.integer  "strength4_id"
    t.integer  "strength5_id"
    t.datetime "sponsored_project_effort_last_emailed"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "github"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                        :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "webiso_account"
    t.string   "login",                                 :limit => 40
    t.string   "email",                                 :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_staff",                                             :default => false
    t.boolean  "is_student",                                           :default => false
    t.boolean  "is_admin",                                             :default => false
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
    t.integer  "updated_by_user_id"
    t.integer  "version"
    t.boolean  "is_alumnus"
    t.string   "pronunciation"
    t.datetime "google_created"
    t.datetime "twiki_created"
    t.datetime "adobe_created"
    t.datetime "msdnaa_created"
    t.integer  "sign_in_count_old",                                    :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "yammer_created"
    t.integer  "strength1_id"
    t.integer  "strength2_id"
    t.integer  "strength3_id"
    t.integer  "strength4_id"
    t.integer  "strength5_id"
    t.datetime "sponsored_project_effort_last_emailed"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "github"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                        :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["human_name"], :name => "index_users_on_human_name"
  add_index "users", ["is_active"], :name => "index_users_on_is_active"
  add_index "users", ["is_staff"], :name => "index_users_on_is_staff"
  add_index "users", ["is_student"], :name => "index_users_on_is_student"
  add_index "users", ["is_teacher"], :name => "index_users_on_is_teacher"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["twiki_name"], :name => "index_users_on_twiki_name"

  create_table "versions", :force => true do |t|
    t.integer  "versioned_id"
    t.string   "versioned_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "user_name"
    t.text     "modifications"
    t.integer  "number"
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reverted_from"
  end

  add_index "versions", ["created_at"], :name => "index_versions_on_created_at"
  add_index "versions", ["number"], :name => "index_versions_on_number"
  add_index "versions", ["tag"], :name => "index_versions_on_tag"
  add_index "versions", ["user_id", "user_type"], :name => "index_versions_on_user_id_and_user_type"
  add_index "versions", ["user_name"], :name => "index_versions_on_user_name"
  add_index "versions", ["versioned_id", "versioned_type"], :name => "index_versions_on_versioned_id_and_versioned_type"

end
