class GradesController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!
  before_filter :get_course
  before_filter :validate_permission

  def get_course
    @course=Course.find(params[:course_id])
  end

  def validate_permission
    unless (current_user.is_admin? || @course.faculty.include?(current_user))
      has_permissions_or_redirect(:admin, root_path)
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

  def create
    puts "in create"

    scoreArrayList=params["scoreArrayList"]
    success=true
    unless scoreArrayList.blank?
      scoreArrayList.each do|scoreValue|
        if  Grade.give_grade(scoreValue["assignment_id"],scoreValue["student_id"],scoreValue["score"])==false
         success=false
        end
        puts success
      end
    end

    scoreSubmitted=params["scoreSubmitted"]
     if (scoreSubmitted==true)
       courseAssignment=params["courseAssignment"]
       Grade.update_grade(courseAssignment["course_id"],courseAssignment["assignment_id"])   
     end


      if success==true
        flash[:notice] = 'Feedback successfully saved.'
        render :json => ({"message"=>"true" })
      else
        flash[:error] = "input format is wrong"
        render :json => ({"message"=> "false"})
      end
  end

  def post_all
    puts "Lydian"
    puts params
    puts "Lydian"
    grades = params["grades"]
    puts grades
    puts "Lydian"
    Grade.give_grades(grades)
    Grade.post_all(@course.id)
    render :json => ({"message"=>"true"})
  end

end
