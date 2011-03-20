class CourseNumbersController < ApplicationController
  layout 'cmu_sv'

  before_filter :require_user

  
  # GET /course_numbers
  # GET /course_numbers.xml
  def index
    @courses = Course.find(:all, :select => "DISTINCT number, name", :order => 'number ASC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_numbers }
    end
  end

end


