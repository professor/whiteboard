class CreateDeliverables < ActiveRecord::Migration
  def self.up
    create_table "deliverable_revisions", :force => true do |t|
      t.integer  "deliverable_id"
      t.integer  "submitter_id"
      t.datetime "submission_date"
      t.string   "revision_file_name"
      t.string   "revision_content_type"
      t.integer  "revision_file_size"
      t.text     "comment"
    end

    create_table :deliverables do |t|
      t.text     "description"
      t.integer  "team_id"
      t.integer  "course_id"
      t.string   "task_number"
      t.integer  "is_team_deliverable"
      t.integer  "creator_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :deliverables
    drop_table :deliverable_revisions
  end
end
