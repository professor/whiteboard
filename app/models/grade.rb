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
require 'spreadsheet'

class Grade < ActiveRecord::Base
  attr_accessible :course_id, :student_id, :assignment_id, :is_student_visible, :score
  belongs_to :course
  belongs_to :student, :class_name => "User"
  belongs_to :assignment
  validates :course_id, :student_id, :assignment_id, :presence => true
  validates :score, :uniqueness => {:scope => [:course_id, :assignment_id, :student_id]}, :allow_nil => true, :allow_blank => true

  before_save :format_score
  after_find :decrypt_score

  FIRST_GRADE_ROW = 2
  FIRST_GRADE_COL = 4

  def format_score
    self.score = GradingRule.format_score(self.course.id, self.score)
    if self.assignment_id < 0
      self.score = Grade.encrypt_score(self.score, self.course_id, self.student_id)
    end
  end

  def decrypt_score
    if self.assignment_id < 0
      self.score = Grade.decrypt_score(self.score, self.course_id, self.student_id)
    end
  end

  # To fetch the grade of student.
  def self.get_grades_for_student_per_course (course, student)
    grades = {}
    Grade.where(course_id: course.id).where(student_id: student.id).each do |grade|
      if grade.assignment_id < 0
        grade.score = Grade.decrypt_score(grade.score, grade.course_id, grade.student_id)
        grades["final"] = grade
      else
        grades[grade.assignment.id] = grade
      end
    end
    grades
  end

  # To fetch the entry with matching course, assignment and student.
  def self.get_grade(assignment_id, student_id)
    Grade.find_by_assignment_id_and_student_id(assignment_id, student_id)
  end

  def self.get_final_grade(course_id, student_id)
    grade = Grade.where(course_id: course_id).where(student_id: student_id).where(:assignment_id => -1)[0]
    if grade.nil?
      ""
    else
      Grade.decrypt_score(grade.score, grade.course_id, grade.student_id)
    end
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

      if course.grading_rule.validate_score(score)
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
    if assignment_id > 0
      feedback = make_feedback_for_one_assignment
    else
      feedback = make_feedback_for_final_grade
    end
    url="whiteboard.sv.cmu.edu/people/#{self.student_id}/my_deliverables"
    options = {:to => self.student.email,
               :subject => "Grade for " + self.course.name,
               :message => feedback,
               :url_label => "Click here to view grade",
               :url => url
              }

    GenericMailer.email(options).deliver
  end

  def self.mail_drafted_grade(course_id, changed_grades)
    draft_grades = Grade.find_all_by_is_student_visible_and_course_id(false, course_id)
    draft_grade.concat(changed_grades)
    draft_grade.each do |grade|
      unless (grade.score.nil? || grade.score.empty?)
        grade.is_student_visible = true
        grade.save
        grade.send_feedback_to_student
      end
    end
  end

  def self.mail_final_grade(course_id, changed_grades)
    final_grades = Grade.find_all_by_course_id_and_assignment_id(course_id, -1)
    final_grades.concat(changed_grades)
    final_grades.each do |grade|
      unless (grade.score.nil? || grade.score.empty? || grade.assignment_id!=-1)
        grade.is_student_visible = true
        grade.save
        grade.send_feedback_to_student
      end
    end
  end

  def self.import_grade_book_from_spreadsheet(file_path)
    Spreadsheet.client_encoding = 'UTF-8'
    grade_book = Spreadsheet.open(file_path)
    grade_sheet = grade_book.worksheet(0)

    if validate_sheet(grade_sheet)
      import_scores(grade_sheet)
      return true
    else
      return false
    end
  end

  def self.export_grade_book_to_spreadsheet(course, file_path)
    Spreadsheet.client_encoding = 'UTF-8'
    grade_book = Spreadsheet::Workbook.new
    grade_sheet = grade_book.create_worksheet
    grade_sheet.name = "#{course.short_name}"

    # print course id and assignment id
    grade_sheet[0,0] = course.id
    course.assignments.each_with_index do |assignment, i|
      grade_sheet[0, FIRST_GRADE_COL+i] = assignment.id
    end
    assignment_count = course.assignments.count
    grade_sheet[0, FIRST_GRADE_COL+assignment_count] = -1
    grade_sheet.row(0).hidden = true

    # print details
    grade_sheet[1,1] = "First Name"
    grade_sheet[1,2] = "Last Name"
    grade_sheet[1,3] = "Team Name"

    grade_sheet.column(0).hidden=true
    course.assignments.each_with_index do |assignment, j|
      grade_sheet[1, FIRST_GRADE_COL+j] = assignment.name
    end
    grade_sheet[1, FIRST_GRADE_COL+assignment_count] = "Final Grade"

    # print students' names and grades
    course.registered_students.each_with_index do |student, i|
      grade_sheet[FIRST_GRADE_ROW+i, 0] = student.id
      grade_sheet[FIRST_GRADE_ROW+i, 1] = student.first_name
      grade_sheet[FIRST_GRADE_ROW+i, 2] = student.last_name
      grade_sheet[FIRST_GRADE_ROW+i, 3] = self.find_student_team(course.id, student.id).name
      course.assignments.each_with_index do |assignment, j|
        score=Grade.get_grade(assignment.id, student.id).try(:score) || ""
        if !course.grading_rule.validate_letter_grade(score)
          score=score.to_f
        end
        grade_sheet[FIRST_GRADE_ROW+i, FIRST_GRADE_COL+j] = score
      end
      grade_sheet[FIRST_GRADE_ROW+i, FIRST_GRADE_COL+assignment_count] = Grade.get_final_grade(course.id, student.id)
    end
    grade_book.write(file_path)
  end
  def self.find_student_team course_id, student_id
    team = User.find(student_id).teams.find_by_course_id(course_id)
    return team

  end

private
  def make_feedback_for_one_assignment
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
  end

  def make_feedback_for_final_grade
    feedback = "Final grade has been assigned for "
    feedback += self.course.name + "\n"
  end

  def self.validate_first_row(row)
    num_cols = row.length
    if num_cols < (FIRST_GRADE_COL+1)
      return false
    end

    # check course ID at sheet[0,0]
    course = Course.find_by_id(row[0].to_i)
    if course.nil?
      return false
    end

    # check assignment IDs
    is_found_final_grade_col = false
    for j in (FIRST_GRADE_COL..(num_cols-1))
      assignment_id = row[j].to_i
      if assignment_id > 0
        # the assignment should be able to be found.
        assignment = Assignment.find_by_id(assignment_id)
        if assignment.nil?
          return false
        end
        # the assignment should belong to this course.
        if assignment.course.id != course.id
          return false
        end
      elsif assignment_id < 0
        # final grade column should not be redundant.
        if is_found_final_grade_col
          return false
        else
          is_found_final_grade_col = false
        end
      else
        # the format of assignment id is incorrect.
        return false
      end
    end

    return true
  end

  def self.validate_first_column(col)
    num_rows = col.length
    if num_rows < (FIRST_GRADE_ROW+1)
      return false
    end

    course = Course.find_by_id(col[0].to_i)
    if course.nil?
      return false
    end

    for i in (FIRST_GRADE_ROW..(num_rows-1))
      student = User.find_by_id(col[i].to_i)
      if student.nil?
        return false
      end

      unless course.registered_students.include?(student)
        return false
      end
    end

    return true
  end

  def self.validate_sheet(grade_sheet)
    (validate_first_row(grade_sheet.row(0).to_a) && validate_first_column(grade_sheet.column(0).to_a))
  end

  def self.import_scores (grade_sheet)
    course_id = grade_sheet[0,0].to_i
    num_rows = grade_sheet.row_count()
    num_cols = grade_sheet.column_count()
    for i in (FIRST_GRADE_ROW..(num_rows-1))
      for j in (FIRST_GRADE_COL..(num_cols-1))
        student_id = grade_sheet[i,0].to_i
        assignment_id = grade_sheet[0,j].to_i
        score = grade_sheet[i,j].to_s
        Grade.give_grade(course_id, assignment_id, student_id, score, true)
      end
    end
  end

  def self.encrypt_score(raw_score, course_id, student_id)
    # FIXME: get salt from somewhere else
    salt="I am salt without any iodine"
    if raw_score.nil? || raw_score.empty?
      return raw_score
    else
      return Digest::SHA2.hexdigest(salt+raw_score+course_id.to_s+student_id.to_s)
    end
  end

  def self.decrypt_score(encrypted_score, course_id, student_id)
    if encrypted_score.nil? || encrypted_score.empty?
      return ""
    end

    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return ""
    end

    grading_rule.letter_grades.each do |letter|
      return letter if encrypted_score == encrypt_score(letter, course_id, student_id)
    end
    return encrypted_score
  end
end

