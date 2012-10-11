class GradeBooksController < ApplicationController
  before_filter :get_course

  layout 'cmu_sv'
  def get_course
    @course=Course.find(params[:course_id])
  end
  
  def index
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
        grade_book = GradeBook.where(:course_id =>scoreValue["course_id"],:assignment_id => scoreValue["assignment_id"],:student_id => scoreValue["student_id"]).limit(1)[0]
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
       puts "score submitted"
       courseAssignment=params["courseAssignment"]
       puts ""
       GradeBook.update_all({:is_student_visible=>true},{:course_id=>courseAssignment["course_id"],:assignment_id=>courseAssignment["assignment_id"],:is_student_visible=>false})

     end
    if error==false
      render :json => ({"success"=> "true","message"=>"Success" })
    else
      render :json => ({"success"=> "false"})
    end
  end

end
