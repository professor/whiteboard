class FacultyAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

#  self.table_name = "courses_people"
#  self.table_name = "faculty_assignments"


end
