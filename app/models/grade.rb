# Grade represents a grade given by the course instructor.
#
# Grade allows the professor to grade students. Professor can go to Grade by clicking Grade tab in faculty
# tools, on the index page of each course. Professor can assign/view/change the score of the student directly
# by putting the score for the assignment in front of his/her name. Also, only one grade is permitted for one student
# per assignment. The design of grade is to encapusulate the grading from the submission.
#
# * For a course, a student will have at most one grade on each assignment.
# * is_student_visible indicates that whether this grade is going to publish to student or not. 
# * score would be in two forms. If the grading rule is set to use points, the score should be a number greater than
#   zero, and we don't validate whether the score is greater than maximum number defined in Assignment object, so that
#   professor can add extra credit on student's grade. If the grading rule is set to use letter grades, score would be
#   A, A-, B+, B, B-, C+, C, or C-.
# * score= assigns a number greater than zero, and we don't validate whether the score is greater than maximum
#   number defined in Assignment object, so that professor can add extra credit on student's grade.
# * get_grades_for_student_per_course returns a list of assignment score of given course and student.
# * get_grade returns a specific one assignment score of given course_id, student_id and assignment_id. This function is
#   useful for controller to test whether the score is existed or not.
# * give_grade saves the grade given for a student's assignment.
# * give_grades saves a list of assignment grades given to a group of students.
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

  before_save :format_score

  def format_score
    self.score = GradingRule.format_score(self.course.id, self.score)
  end
  
  # To fetch the grade of student.
  def self.get_grades_for_student_per_course (course, student)
    grades = {}
    Grade.where(course_id: course.id).where(student_id: student.id).each do |grade|
      if grade.assignment_id < 0
        grades["final"] = grade
      else
        grades[grade.assignment.id] = grade
      end
    end
    grades
  end

  # To fetch the entry with matching course, assignment and student.
  def self.get_grade(assignment_id, student_id)
    grade = Grade.find_by_assignment_id_and_student_id(assignment_id, student_id)
  end

  # To assign/update the grade to the student
  def self.give_grade(course_id, assignment_id, student_id, score,is_student_visible=nil)
    if assignment_id>0
      if Assignment.find(assignment_id).nil?
        return false
      end
    end

    grading_result = false
    student = User.find(student_id)
    course = Course.find(course_id)
    if course.registered_students.include?(student)
      grade = Grade.get_grade(assignment_id, student_id)
      if grade.nil?
        grade = Grade.new({:course_id=>course_id, :assignment_id => assignment_id, :student_id=> student_id,
                           :score =>score,:is_student_visible=>is_student_visible})
      end

      if GradingRule.validate_score(course_id, score)
        grade.score=score.upcase
        unless is_student_visible.nil?
          grade.is_student_visible = is_student_visible
        end
        grading_result = grade.save
      else
        grading_result=false
      end
    end
    grading_result
  end

  # To assign grades for to multiple students
  def self.give_grades(grades)
    grades.each do |grade_entry|
      # FIXME: error handling for update failure
      self.give_grade(grade_entry[:course_id], grade_entry[:assignment_id], grade_entry[:student_id], grade_entry[:score], grade_entry[:is_student_visible])
    end
  end

  def send_feedback_to_student
    feedback = "Grade has been submitted for "
    if !self.assignment.task_number.nil? and self.assignment.task_number != "" and !self.assignment.name.nil? and self.assignment.name !=""
      feedback += "#{self.assignment.name} (#{self.assignment.task_number}) of "
    end
    feedback +=self.course.name


      feedback += "\nGrade earned for this assignment is: "
      feedback += self.score.to_s
      feedback+= " /"
      feedback+= self.assignment.maximum_score.to_s
      feedback += "\n"


    options = {:to => self.student.email,
               :subject => "Grade for " + self.course.name,
               :message => feedback
              }

    GenericMailer.email(options).deliver
  end

  def self.mail_drafted_grade course_id
    Grade.find_all_by_is_student_visible_and_course_id(false, course_id).each do |grade|
      grade.is_student_visible = true
      grade.save
      grade.send_feedback_to_student
    end
  end



end

