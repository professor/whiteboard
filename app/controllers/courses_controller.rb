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
#    @semester_courses = Course.for_semester(@semester, @year, "Both")
#    @mini_a_courses = Course.for_semester(@semester, @year, "A")
#    @mini_b_courses = Course.for_semester(@semester, @year, "B")
#
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
    if has_permissions_or_redirect(:staff, root_url)
      @course = Course.new
      @course.semester = AcademicCalendar.next_semester
      @course.year = AcademicCalendar.next_semester_year

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @course }
      end
    end   
  end

  # GET /courses/1/edit
  def edit
    if has_permissions_or_redirect(:staff, root_url)
      @course = Course.find(params[:id])
    end
  end

  def configure
    if has_permissions_or_redirect(:staff, root_url)
      edit
    end
  end

  # POST /courses
  # POST /courses.xml
  def create
    if has_permissions_or_redirect(:staff, root_url)
      @last_offering = Course.last_offering(params[:course][:number])
      if @last_offering.nil?
        @course = Course.new(:name => "New Course", :mini => "Both", :number => params[:course][:number])
      else
        @course = @last_offering.copy_as_new_course
      end

      @course.year = params[:course][:year]
      @course.semester = params[:course][:semester]

      respond_to do |format|
        if @course.save

          flash[:notice] = 'Course was successfully created.'
          format.html { redirect_to edit_course_path(@course) }
          format.xml  { render :xml => @course, :status => :created, :location => @course }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    if has_permissions_or_redirect(:staff, root_url)
      @course = Course.find(params[:id])

      if(params[:course][:is_configured]) #The previous page was configure action
        @course.twiki_url = params[:course][:curriculum_url] if @course.twiki_url.blank? && params[:course][:configure_course_twiki]
      else
        msg = @course.update_people(params[:people])
        unless msg.blank?
          flash.now[:error] = msg
          render :action => 'edit'
          return
        end
      end

      respond_to do |format|
        if @course.update_attributes(params[:course])
          if(params[:course][:is_configured]) #The previous page was configure action
            CourseMailer.deliver_configure_course_admin_email(@course)
          end
          flash[:notice] = 'Course was successfully updated.'
          format.html { redirect_to(@course) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @course.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    if has_permissions_or_redirect(:admin, root_url)
      @course = Course.find(params[:id])
      @course.destroy

      respond_to do |format|
        format.html { redirect_to(courses_url) }
        format.xml  { head :ok }
      end
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
