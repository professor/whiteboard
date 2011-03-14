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
  
  def current_semester
    @all_courses = false
    @semester = AcademicCalendar.current_semester()
    @year = Date.today.year
    @courses = Course.for_semester(@semester, @year)
    index_core
  end

  def next_semester
    @all_courses = false
    @semester = AcademicCalendar.next_semester()
    @year = AcademicCalendar.next_semester_year()
    @courses = Course.for_semester(@semester, @year)
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
    @course.semester = AcademicCalendar.next_semester
    @course.year = AcademicCalendar.next_semester_year

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  def configure
    edit
  end

  # POST /courses
  # POST /courses.xml
  def create
    @course = Course.new(params[:course])

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

    if(params[:course][:is_configured]) #The previous page was configure action
      CourseMailer.deliver_configure_course_admin_email(@course)
    end

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
