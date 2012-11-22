class GradesController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!
  before_filter :get_course
  before_filter :render_grade_book_menu
  before_filter :validate_permission
  before_filter :get_team_assignment, :only=>:index

  def get_course
    @course=Course.find(params[:course_id])
  end

  def render_grade_book_menu
    @is_in_grade_book = true
  end

  def validate_permission
    unless (current_user.is_admin? || @course.faculty.include?(current_user))
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  def get_team_assignment
    @team_assignment = {}
    @course.teams.each do |t|
      t.members.each do |m|
        @team_assignment[m.id] = t
      end
    end
  end


  def index
    @no_pad = true
    @students = @course.registered_students.order("first_name ASC")
    @assignments = @course.assignments
    @grades = {}
    @students.each do |student|
      @grades[student] =  Grade.get_grades_for_student_per_course(@course, student)
    end
  end

  def post_drafted_and_send #and send email
    grades = params["grades"]
    #Grade.give_grades(grades)
    Grade.mail_drafted_grade @course.id
    render :json => ({"message"=>"true"})
  end

  def save
    grades = params["grades"]
    Grade.give_grades(grades)
    render :json => ({"message"=>"true"})
  end

  def validate_excel sheet1
    sheet1.each_with_index do |row, i|
      if i == 0
        course = Course.find_by_id(row[0].to_i)
        if course.nil?
          puts "can't find course " + row[0]
        end
        row.each_with_index do |col, j|
          if j > 2
            assignment = Assignment.find_by_id(col.to_i)
            if assignment.nil?
              puts "can't find assignment " + col.to_s
            else
              if assignment.course_id != course.id
                puts "::::: Not for this course"+ assignment.inspect
              end
              puts "!!!!!!! Passed" + assignment.inspect
            end
          end
        end

      else
        course = Course.find_by_id(sheet1[0,0].to_i)
        student = User.find_by_id(row[0].to_i)
        unless course.registered_students.include?(student)
          puts student.inspect + " not registered"
          #return false
        else
          puts student.inspect + " passed"
        end
      end
    end
  end

  def import_scores (sheet1)
    @sheet1=sheet1
    course_id=Course.find_by_id(sheet1[0,0].to_i)
    sheet1.each_with_index do  |row, i|
       if i>=2
         student_id=row[0].to_i
         row.each_with_index do |col, j|
         if j>=2
             assignment_id=get_assignment_id( j)
             score=col.to_s
             Grade.give_grade(course_id,assignment_id,student_id,score, false)
          end
         end
       end

    end
    #sheet1.each_with_index do |row, i|
    #  assignmes
    #  if i == 0
    #
    #  else if i >= 2
    #    row.each_with_index do |col, j|
    #      if j >= 2
    #        Grade.give
    #      end
    #    end
    #  end
    #end
  end

  def get_assignment_id (j)
    return @sheet1[0,j].to_i
  end

  def import
    require 'spreadsheet'

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open "/Users/kate/Downloads/Workbook1.xls"
    sheet1 = book.worksheet(0)

    validate_excel(sheet1)
    import_scores(sheet1)

    #sheet1[0].each_with_index do |index, col|
    #  if index > 2
    #    assignment = Assignment.find_by_id(col[index].to_i)
    #    if assignment.nil?
    #      puts "can't find assignment " + col[index].to_i
    #    end
    #  end
    #end



  end
end
