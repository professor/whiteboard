class FacultyAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

#  set_table_name "courses_people"
#  set_table_name "faculty_assignments"


end
