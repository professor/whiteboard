class GradeBooksController < ApplicationController
  def index
    @course = Course.find(1)
    @students = @course.registered_students
    @assignments = @course.assignments
    @grade_books = @course.grade_books 
  end
end
