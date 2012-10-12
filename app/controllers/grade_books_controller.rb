class GradeBooksController < ApplicationController
  before_filter :get_course

  layout 'cmu_sv'
  def get_course
    @course=Course.find(params[:course_id])
  end
  
  def index
    #@no_pad = true
    @students = @course.registered_students
    @assignments = @course.assignments
    @grade_books = {}
    @students.each do |student|
      @grade_books[student] =  GradeBook.get_gradebooks(@course, student)
    end
    end

  def create
    puts "in create"

    scoreArrayList=params["scoreArrayList"]
    error=false
    unless scoreArrayList.blank?
      scoreArrayList.each do|scoreValue|
      grade_book = GradeBook.get_grade_books(scoreValue)
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
       GradeBook.update_gradebook(courseAssignment)   
     end
    if error==false
      render :json => ({"success"=> "true","message"=>"Success" })
    else
      flash[:error] = "input format is wrong"
      render :json => ({"success"=> "false"})
    end
  end

end
