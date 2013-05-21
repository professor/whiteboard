class AddIndexesIdentifiedByRailsBestPractices < ActiveRecord::Migration
  def self.up
    add_index :assignments, :course_id
    add_index :courses, :course_number_id
    add_index :curriculum_comments, :user_id
    add_index :curriculum_comments, :curriculum_comment_type_id
    add_index :deliverable_attachment_versions, :deliverable_id
    add_index :deliverables, :team_id
    add_index :deliverables, :course_id
    add_index :deliverables, :creator_id
    add_index :effort_log_line_items, :course_id
    add_index :effort_log_line_items, :task_type_id
    add_index :grades, :course_id
    add_index :grades, :student_id
    add_index :grades, :assignment_id
    add_index :grading_rules, :course_id
    add_index :page_attachments, :user_id
    add_index :page_comments, :page_comment_type_id
    add_index :people_search_defaults, :user_id
    add_index :presentations, :team_id
    add_index :presentations, :user_id
    add_index :teams, :primary_faculty_id
    add_index :teams, :secondary_faculty_id
    add_index :user_versions, :user_id
    add_index :users, :strength1_id
    add_index :users, :strength2_id
    add_index :users, :strength3_id
    add_index :users, :strength4_id
    add_index :users, :strength5_id
  end

  def self.down
    remove_index :assignments, :course_id
    remove_index :courses, :course_number_id
    remove_index :curriculum_comments, :user_id
    remove_index :curriculum_comments, :curriculum_comment_type_id
    remove_index :deliverable_attachment_versions, :deliverable_id
    remove_index :deliverables, :team_id
    remove_index :deliverables, :course_id
    remove_index :deliverables, :creator_id
    remove_index :effort_log_line_items, :course_id
    remove_index :effort_log_line_items, :task_type_id
    remove_index :grades, :course_id
    remove_index :grades, :student_id
    remove_index :grades, :assignment_id
    remove_index :grading_rules, :course_id
    remove_index :page_attachments, :user_id
    remove_index :page_comments, :page_comment_type_id
    remove_index :people_search_defaults, :user_id
    remove_index :presentations, :team_id
    remove_index :presentations, :user_id
    remove_index :teams, :primary_faculty_id
    remove_index :teams, :secondary_faculty_id
    remove_index :user_versions, :user_id
    remove_index :users, :strength1_id
    remove_index :users, :strength2_id
    remove_index :users, :strength3_id
    remove_index :users, :strength4_id
    remove_index :users, :strength5_id
  end
end
