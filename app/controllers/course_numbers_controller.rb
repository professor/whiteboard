class CourseNumbersController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!


  # GET /course_numbers
  # GET /course_numbers.xml
  def index
    @courses = Course.unique_course_numbers_and_names_by_number

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @course_numbers }
    end
  end

end


