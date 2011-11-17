class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string   "name"
      t.text     "description"
      t.integer  "team_id"
      t.integer  "course_id"
      t.string   "task_number"
      t.integer  "creator_id"
      t.datetime "present_date"
      t.timestamps
    end
  end

  def self.down
    drop_table :presentations
  end
end
