# GradeBook represents a grade given by the course instructor.
# 
# == Viewing grades
# 
# == Modifying grades
#
class GradeBook < ActiveRecord::Base
  attr_accessible :course_id, :student_id, :assignment_id, :is_student_visible, :score
  belongs_to :course
  belongs_to :student, :class_name => "User"
  belongs_to :assignment
  validates :course_id, :student_id, :assignment_id, :presence => true 
  validates :score, :numericality => {:greater_than_or_equal_to => 0} , :allow_nil => true, :allow_blank => true
  validates :score, :uniqueness => {:scope => [:course_id, :assignment_id, :student_id]}

  def self.get_gradebooks (course, student)
    grade_books = {}
    GradeBook.where(course_id: course.id).where(student_id: student.id).each do |grade_book|
      grade_books[grade_book.assignment.id] = grade_book
    end
    grade_books
  end

  def self.get_grade_books(score_value)
    grade_book = GradeBook.where(:course_id =>score_value["course_id"],:assignment_id => score_value["assignment_id"],:student_id => score_value["student_id"]).limit(1)[0]
  end

  def self.update_gradebook(course_assignment)
    GradeBook.update_all({:is_student_visible=>true},{:course_id=>course_assignment["course_id"],:assignment_id=>course_assignment["assignment_id"],:is_student_visible=>false})
  end

end

