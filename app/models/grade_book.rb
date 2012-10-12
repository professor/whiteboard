class GradeBook < ActiveRecord::Base
  attr_accessible :course_id, :student_id, :assignment_id, :is_student_visible, :score
  belongs_to :course
  belongs_to :student, :class_name => "User"
  belongs_to :assignment

  def self.get_gradebooks (course, student)
    gradebooks = {}
    GradeBook.where(course_id: course.id).where(student_id: student.id).each do |gradebook|
      gradebooks[gradebook.assignment.id] = gradebook 
    end
    gradebooks 
  end

  def self.get_grade_books(scoreValue)
        grade_book = GradeBook.where(:course_id =>scoreValue["course_id"],:assignment_id => scoreValue["assignment_id"],:student_id => scoreValue["student_id"]).limit(1)[0]
  end
  def self.update_gradebook(courseAssignment)
       GradeBook.update_all({:is_student_visible=>true},{:course_id=>courseAssignment["course_id"],:assignment_id=>courseAssignment["assignment_id"],:is_student_visible=>false})

  end

end

