class GradeBooksController < ApplicationController
  before_filter :get_course

  layout 'cmu_sv'
  def get_course
    @course=Course.find(params[:course_id])
  end
  
  def index
    @no_pad = true
    @students = @course.registered_students.order("first_name ASC")
    @assignments = @course.assignments
    @grade_books = {}
    @students.each do |student|
      @grade_books[student] =  GradeBook.get_grade_books(@course, student)
    end
    end

  def create
    puts "in create"

    scoreArrayList=params["scoreArrayList"]
    error=false
    unless scoreArrayList.blank?
      scoreArrayList.each do|scoreValue|
      grade_book = GradeBook.get_grade_book(scoreValue["course_id"], scoreValue["assignment_id"],scoreValue["student_id"])
        if  grade_book.blank?
          grade_book_entry=GradeBook.new(scoreValue)
          unless grade_book_entry.save
            error=true
          end
        else
          begin
            puts "update score"
            unless grade_book.update_attributes(scoreValue)
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
       GradeBook.update_grade_book(courseAssignment["course_id"],courseAssignment["assignment_id"])   
     end
    if error==false
      render :json => ({"success"=> "true","message"=>"Success" })
    else
      flash[:error] = "input format is wrong"
      render :json => ({"success"=> "false"})
    end
  end

end
