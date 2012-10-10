class GradebooksController < ApplicationController
  def index
    @course = Course.find(1)
    @students = @course.registered_students
    @assignments = @course.assignments
    @gradebooks = @course.grade_books 
  end
end
