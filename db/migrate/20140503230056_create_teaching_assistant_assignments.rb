class CreateTeachingAssistantAssignments < ActiveRecord::Migration
  def up
    create_table "teaching_assistant_assignments", id: false, force: true do |t|
      t.integer  "course_id"
      t.integer  "user_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "teaching_assistant_assignments", ["course_id", "user_id"], name: "index_teaching_assistant_assignments_on_course_id_and_person_id", unique: true
  end

  def down
    remove_index "teaching_assistant_assignments", name: "index_teaching_assistant_assignments_on_course_id_and_person_id"

    drop_table "teaching_assistant_assignments"
  end
end
