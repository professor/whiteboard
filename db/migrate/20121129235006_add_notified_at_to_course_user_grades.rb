class AddNotifiedAtToCourseUserGrades < ActiveRecord::Migration
  def self.up
    add_column :course_user_grades, :notified_at, :datetime
  end

  def self.down
    remove_column :course_user_grades, :notified_at
  end
end
