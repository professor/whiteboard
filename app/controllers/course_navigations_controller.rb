class CourseNavigationsController < ApplicationController
  layout 'cmu_sv_no_pad'

  before_filter :authenticate_user!

  #Inspiration for this technique comes from two sources
  # A: http://awesomeful.net/posts/47-sortable-lists-with-jquery-in-rails (yield javascript, jquery ui code)
  # B: http://henrik.nyh.se/2008/11/rails-jquery-sortables#comment-17220662 (model update code)


  # GET /course_navigations/1
  # GET /course_navigations/1.xml
  def show
    @course = Course.find(params[:id])
    @pages = @course.pages

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @pages }
    end
  end

  def reposition
    order = params[:page]
    Page.reposition(order)
    render :text => order.inspect
  end

end
