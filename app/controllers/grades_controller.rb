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
    Grade.mail_drafted_grade(@course.id, grades)
    render :json => ({"message"=>"true"})
  end

  def save
    grades = params["grades"]
    Grade.give_grades(grades)
    render :json => ({"message"=>"true"})
  end

  def send_final_grade
    grades = params["grades"]
    Grade.mail_final_grade(@course.id, grades)
    render :json => ({"message"=>"true"})
  end

  def import
    if params[:import].nil? || params[:import][:spreadsheet].nil?
      flash[:error] = "please select a file to import"
      redirect_to course_grades_path(@course) and return
    end

    temp_file_path = params[:import][:spreadsheet].path
    if Grade.import_grade_book_from_spreadsheet(temp_file_path)
      flash[:notice] = "grade book was imported"
    else
      flash[:error] = "spreadsheet format is incorrect"
    end
    redirect_to course_grades_path(@course)
  end

  def export
    temp_file_path = File.expand_path('~') + "/Downloads/export.xls"
    Grade.export_grade_book_to_spreadsheet(@course, temp_file_path)
    flash[:notice] = "grade book was exported to " + temp_file_path
    send_file(temp_file_path, :filename=>"GradeBook_#{@course.name}.xls")
  end
end
