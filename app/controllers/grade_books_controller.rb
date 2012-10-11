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
end
