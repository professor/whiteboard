class GradeBook < ActiveRecord::Base
  attr_accessible :course, :student, :assignment
  belongs_to :course
  belongs_to :student, :class_name => "User"
  #has_many :studnets, :source => :user
  belongs_to :assignment
  #has_many :assignments

  def self.get_scores (course, student)
    GradeBook.where(course_id: course.id).where(student_id: student.id)
  end
end

