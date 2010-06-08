class CourseNumbersController < ApplicationController
  layout 'cmu_sv'

  before_filter :login_from_cookie
#   before_filter :login_required

  
  # GET /course_numbers
  # GET /course_numbers.xml
  def index
    @course_numbers = CourseNumber.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @course_numbers }
    end
  end

  # GET /course_numbers/1
  # GET /course_numbers/1.xml
  def show
    @course_number = CourseNumber.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course_number }
    end
  end

  # GET /course_numbers/new
  # GET /course_numbers/new.xml
  def new
    @course_number = CourseNumber.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course_number }
    end
  end

  # GET /course_numbers/1/edit
  def edit
    @course_number = CourseNumber.find(params[:id])
  end

  # POST /course_numbers
  # POST /course_numbers.xml
  def create
    @course_number = CourseNumber.new(params[:course_number])

    respond_to do |format|
      if @course_number.save
        flash[:notice] = 'Course Number was successfully created.'
        format.html { redirect_to(@course_number) }
        format.xml  { render :xml => @course_number, :status => :created, :location => @course_number }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course_number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /course_numbers/1
  # PUT /course_numbers/1.xml
  def update
    @course_number = CourseNumber.find(params[:id])

    respond_to do |format|
      if @course_number.update_attributes(params[:course_number])
        flash[:notice] = 'Course Number was successfully updated.'
        format.html { redirect_to(@course_number) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course_number.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /course_numbers/1
  # DELETE /course_numbers/1.xml
  def destroy
    @course_number = CourseNumber.find(params[:id])
    @course_number.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
      format.xml  { head :ok }
    end
  end
end


