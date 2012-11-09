# Grade represents a grade given by the course instructor.
#
# Grade allows the professor to grade students. Professor can go to Grade by clicking Grade tab in faculty
# tools, on the index page of each course. Professor can assign/view/change the score of the student directly
# by putting the score for the assignment in front of his/her name. Also, only one grade is permitted for one student
# per assignment. The design of grade is to encapusulate the grading from the submission.
#
# * For a course, a student will have at most one grade on each assignment.
# * is_student_visible indicates that whether this grade is going to publish to student or not. 
# * score should be number greater than zero, and we don't validate whether the score is greater than maximum number defined in Assignment object, so that professor can add extra credit on student's grade.
# * get_grades returns a list of assignment score of given course and student.
# * get_grade returns a specific one assignment score of given course_id, student_id and assignment_id. This function is useful for controller to test whether the score is existed or not.
#
# 
#
class Grade < ActiveRecord::Base
  attr_accessible :course_id, :student_id, :assignment_id, :is_student_visible, :score
  belongs_to :course
  belongs_to :student, :class_name => "User"
  belongs_to :assignment
  validates :course_id, :student_id, :assignment_id, :presence => true 
  #validates :score, :numericality => {:greater_than_or_equal_to => 0} , :allow_nil => true, :allow_blank => true
  validates :score, :uniqueness => {:scope => [:course_id, :assignment_id, :student_id]}

  # To fetch the grade of student.
  def self.get_grades_for_student_per_course (course, student)
    grades = {}
    Grade.where(course_id: course.id).where(student_id: student.id).each do |grade|
      grades[grade.assignment.id] = grade
    end
    grades["earned_grade"] = (grades.values.map {|grade|  ((grade.score.nil?) ? 0: grade.score)}).reduce(:+)
    grades
  end


  # To fetch the entry with matching course, assignment and student.
  def self.get_grade(assignment_id, student_id)
    grade = Grade.find_by_assignment_id_and_student_id(assignment_id, student_id)
  end


  def score
    GradingRule.get_grade_in_prof_format(self.course_id, read_attribute(:score))
  end
  #
  def score=(val)
    write_attribute(:score, GradingRule.get_raw_grade(self.course_id, val))
  end

  def self.post_all(course_id)
    Grade.update_all({:is_student_visible=>true}, {:course_id=>course_id})
  end

  def self.save_as_draft(grades)
    grades.each do |grade_entry|
      Grade.find_by_assignment_id_and_student_id(grade_entry[:assignment_id], grade_entry[:student_id]).try(
          :update_attribute, :is_student_visible, false)
    end
  end

  def self.give_grade(assignment_id, student_id, score,is_student_visible=false)
      grading_result = false
    student = User.find(student_id)

    assignment = Assignment.find(assignment_id)
    if assignment.nil?
      grading_result = false
    elsif assignment.course.registered_students.include?(student)
      raw_score = GradingRule.get_raw_grade(assignment.course.id, score)
      grade = Grade.get_grade(assignment.id, student_id)
      if grade.blank?
        grade = Grade.new({:course_id=>assignment.course.id, :assignment_id => assignment.id, :student_id=> student_id, :score =>raw_score,:is_student_visible=>is_student_visible})
      end
      grade.score=raw_score
      grade.is_student_visible = is_student_visible
      grading_result = grade.save
    end
    grading_result
  end

  def self.give_grades(grades)
    grades.each do |grade_entry|
      # FIXME: error handling for update failure
      self.give_grade(grade_entry[:assignment_id], grade_entry[:student_id], grade_entry[:score])
    end
  end

  def self.post_grades_for_one_assignment(grades, assignment_id)
      grades.each do |grade_entry|
        if grade_entry[:assignment_id] == assignment_id
          self.give_grade(grade_entry[:assignment_id], grade_entry[:student_id], grade_entry[:score])
        end
      end
      Grade.update_all({:is_student_visible=>true},{:assignment_id=>assignment_id})
  end

end

