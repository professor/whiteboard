class FacultyAssignment < ActiveRecord::Base
  belongs_to :person
  belongs_to :course

  set_table_name "courses_people"


end
