class CoursesUsers < ActiveRecord::Migration
  def self.up
    create_table "courses_users", :id => false, :force => true do |t|
      t.integer "course_id"
      t.integer "user_id"
    end
  end

  def self.down
    drop_table "courses_users"
  end
end
