class GradesController < ApplicationController
  before_filter :get_course

  layout 'cmu_sv'
  def get_course
    @course=Course.find(params[:course_id])
  end
  
  def index
    @no_pad = true
    @students = @course.registered_students.order("first_name ASC")
    @assignments = @course.assignments
    @grades = {}
    @students.each do |student|
      @grades[student] =  Grade.get_grades(@course, student)
    end
    end

  def create
    puts "in create"

    scoreArrayList=params["scoreArrayList"]
    error=false
    unless scoreArrayList.blank?
      scoreArrayList.each do|scoreValue|
      grade = Grade.get_grade(scoreValue["course_id"], scoreValue["assignment_id"],scoreValue["student_id"])
        if  grade.blank?
          grade_entry=Grade.new(scoreValue)
          unless grade_entry.save
            error=true
          end
        else
          begin
            puts "update score"
            unless grade.update_attributes(scoreValue)
              error=true
            end
          rescue
            error=true
          end
        end
      end
    end

    scoreSubmitted=params["scoreSubmitted"]
     if (scoreSubmitted==true)
       courseAssignment=params["courseAssignment"]
       Grade.update_grade(courseAssignment["course_id"],courseAssignment["assignment_id"])   
     end
    if error==false
      render :json => ({"success"=> "true","message"=>"Success" })
    else
      flash[:error] = "input format is wrong"
      render :json => ({"success"=> "false"})
    end
  end

end
