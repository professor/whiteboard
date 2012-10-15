# GradeBook represents a grade given by the course instructor.
#
# GradeBook allows the professor to grade students. Professor can go to GradeBook by clicking GradeBook tab in faculty
# tools, on the index page of each course. Professor can assign/view/change the score of the student directly
# by putting the score for the assignment in front of his/her name. Also, only one grade is permitted for one student
# per assignment. The design of gradebook is to encapusulate the grading from the submission.
#
# * For a course, a student will have at most one grade_book on each assignment.
# * is_student_visible indicates that whether this grade is going to publish to student or not. 
# * score should be number greater than zero, and we don't validate whether the score is greater than maximum number defined in Assignment object, so that professor can add extra credit on student's grade.
# * get_grade_books returns a list of assignment score of given course and student. 
# * get_grade_book returns a specific one assignment score of given course_id, student_id and assignment_id. This function is useful for controller to test whether the score is existed or not. 
# * update_grade_book makes all selected assignment grades hidden from students. 
# 
#
class GradeBook < ActiveRecord::Base
  attr_accessible :course_id, :student_id, :assignment_id, :is_student_visible, :score
  belongs_to :course
  belongs_to :student, :class_name => "User"
  belongs_to :assignment
  validates :course_id, :student_id, :assignment_id, :presence => true 
  validates :score, :numericality => {:greater_than_or_equal_to => 0} , :allow_nil => true, :allow_blank => true
  validates :score, :uniqueness => {:scope => [:course_id, :assignment_id, :student_id]}

  # To fetch the grade of student.
  def self.get_grade_books (course, student)
    grade_books = {}
    GradeBook.where(course_id: course.id).where(student_id: student.id).each do |grade_book|
      grade_books[grade_book.assignment.id] = grade_book
    end
    grade_books
  end


  # To fetch the entry with matching course, assignment and student.
  def self.get_grade_book(course_id, assignment_id, student_id)
    grade_book = GradeBook.where(:course_id => course_id,:assignment_id => assignment_id,:student_id => student_id).limit(1)[0]
  end


  # To allow the scores to be visible to the students.
  def self.update_grade_book(course_id, assignment_id)
    GradeBook.update_all({:is_student_visible=>true},{:course_id=>course_id,:assignment_id=>assignment_id,:is_student_visible=>false})
  end

end

