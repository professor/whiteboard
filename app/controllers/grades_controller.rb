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

  def save_draft
    grades = params["grades"]
    Grade.give_grades(grades)
    Grade.save_as_draft(grades)
    render :json => ({"message"=>"true"})
  end

  def save
    grades = params["grades"]
    Grade.give_grades(grades)
    render :json => ({"message"=>"true"})
  end

  def post_grades_for_one_assignment
    grades = params["grades"]
    assignment_id = params["assignment_id"]
    Grade.post_grades_for_one_assignment(grades, assignment_id)
    render :json => ({"message"=>"true"})
  end

end
