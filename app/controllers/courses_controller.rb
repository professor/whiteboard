class CoursesController < ApplicationController
   layout 'cmu_sv'
  
   before_filter :require_user

  # GET /courses
  # GET /courses.xml
  def index
    @all_courses = true
    @courses = Course.find(:all, :order => "year DESC, semester DESC, number ASC")
    @courses = @courses.sort_by { |c| -c.sortable_value } # note the '-' is for desc sorting

    index_core
  end

  
  #can't call this method current_semster since that interfers with the gloabl method
  def current
    @all_courses = false
    @current_semester = ApplicationController.current_semester()
    @year = Date.today.year
    @courses = Course.find(:all, :conditions => ["semester = ? and year = ?", @current_semester, Date.today.year], :order => "name ASC")
    index_core
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find(params[:id])

#    teams = Team.find_by_course_id(params[:id])
    teams = Team.find(:all, :conditions => ["course_id = ?", params[:id]])

    @emails = []
    teams.each do |team|
      team.people.each do |person|
        @emails << person.email
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    @course = Course.new
    @course_numbers = CourseNumber.find(:all, :order => "name")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
    @course_numbers = CourseNumber.find(:all, :order => "name")

  end

  # POST /courses
  # POST /courses.xml
  def create
    @course = Course.new(params[:course])
    @course_template = CourseNumber.find(params[:course][:course_number_id]) if !params[:course][:course_number_id].nil?
    if @course_template
      @course.name = @course_template.name
      @course.number = @course_template.number      
    end

    respond_to do |format|
      if @course.save
        flash[:notice] = 'Course was successfully created.'
        format.html { redirect_to(@course) }
        format.xml  { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        flash[:notice] = 'Course was successfully updated.'
        format.html { redirect_to(@course) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to(courses_url) }
      format.xml  { head :ok }
    end
  end


  private
  def index_core
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml  { render :xml => @courses }
    end
  end
end
