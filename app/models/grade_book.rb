class GradeBook < ActiveRecord::Base
  attr_accessible :course_id, :student_id, :assignment_id, :is_student_visible, :score
  belongs_to :course
  belongs_to :student, :class_name => "User"
  #has_many :studnets, :source => :user
  belongs_to :assignment
  #has_many :assignments

  def self.get_gradebooks (course, student)
    gradebooks = {}
    GradeBook.where(course_id: course.id).where(student_id: student.id).each do |gradebook|
      gradebooks[gradebook.assignment.id] = gradebook 
    end
    gradebooks 
  end
end

