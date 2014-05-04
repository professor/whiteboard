class GradesController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!
  before_filter :get_course
  before_filter :render_grade_book_menu
  before_filter :validate_permission, :except => [:student_deliverables_and_grades_for_course]
  before_filter :get_team_assignment, :only => [:index, :student_deliverables_and_grades_for_course]


  def get_course
    @course=Course.find(params[:course_id])
  end

  def render_grade_book_menu
    @is_in_grade_book = true
  end

  def validate_permission
    unless (current_user.is_admin? || @course.faculty_and_teaching_assistants.include?(current_user))
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
    if @course.grading_rule.nil?
      flash[:error] = I18n.t(:no_grading_rule_for_course)
      redirect_to course_path(@course) and return
    end
    if @course.grading_rule.default_values?
      flash.now[:error] = I18n.t(:default_grading_rule_for_course)
    end
    @no_pad = true
    @students = @course.registered_students_or_on_teams
    @assignments = @course.assignments
    @grades = {}
    @students.each do |student|
      @grades[student] = Grade.get_grades_for_student_per_course(@course, student)
    end
    render
  end

  def student_deliverables_and_grades_for_course
    @course = Course.find(params[:course_id])
    if (params[:user_id])
      @user = User.find_by_param(params[:user_id])
    else
      @user = current_user
    end
    if (current_user.id != @user.id)
      unless (@course.faculty_and_teaching_assistants.include?(current_user))||(current_user.is_admin?)
        flash[:error] = I18n.t(:not_your_deliverable)
        redirect_to root_path and return
      end
    end
    @assignments = @course.assignments
    @grades = {}
    @grades[@user] = Grade.get_grades_for_student_per_course(@course, @user)
    respond_to do |format|
      format.html { render :action => "student_deliverables" }
      format.xml { render :xml => @assignments }
    end
  end

  def post_drafted_and_send #and send email
    grades = params["grades"]
    faculty_email = nil
    if params[:send_copy_to_myself] == "1"
      faculty_email = current_user.email
    end
    Grade.mail_drafted_grade(@course.id, request.host_with_port, faculty_email)
    render :json => ({"message" => "true"})
  end

  def save
    grades = params["grades"]
    Grade.give_grades(grades, current_user.id)
    render :json => ({"message" => "true"})
  end

  def send_final_grade
    grades = params["grades"]
    faculty_email = nil
    if params[:send_copy_to_myself] == "1"
      faculty_email = current_user.email
    end
    Grade.mail_final_grade(@course.id, request.host_with_port, faculty_email)
    render :json => ({"message" => "true"})
  end

  def import
    if params[:import].nil? || params[:import][:spreadsheet].nil?
      flash[:error] = "please select a file to import"
      redirect_to course_grades_path(@course) and return
    end

    temp_file_path = params[:import][:spreadsheet].path
    if Grade.import_grade_book_from_spreadsheet(temp_file_path, @course.id)
      flash[:notice] = "grade book was imported"
    else
      flash[:error] = "spreadsheet format is incorrect"
    end
    redirect_to course_grades_path(@course)
  end

  def export
    temp_file_path = File.expand_path("#{Rails.root}/tmp/#{Process.pid}_") + "export.xls"
    Grade.export_grade_book_to_spreadsheet(@course, temp_file_path)
    flash[:notice] = "grade book was exported to " + temp_file_path
    send_file(temp_file_path, :filename => "GradeBook_#{@course.name}.xls")
  end

end
