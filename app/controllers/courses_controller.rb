class CoursesController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  # GET /courses
  # GET /courses.xml
  def index
    @all_courses = true
    @courses = Course.order("year DESC, semester DESC, number ASC").all
    @courses = @courses.sort_by { |c| -c.sortable_value } # note the '-' is for desc sorting

  end

  def index_for_semester
    @all_courses = false
    (@semester, @year) = AcademicCalendar.semester_and_year(params[:semester])

    @courses = Course.for_semester(@semester, @year)
    @semester_length_courses = @courses.select {|course| course.mini == "Both"}
    @mini_a_courses = @courses.select {|course| course.mini == "A"}
    @mini_b_courses = @courses.select {|course| course.mini == "B"}

    index_core
  end

  #def current_semester
  #  #@all_courses = false
  #  @semester = AcademicCalendar.current_semester()
  #  @year = Date.today.year
  #  params[:semester] = "#{@semester}#{@year}"
  #
  #  #@courses = Course.for_semester(@semester, @year)
  #  #@semester_length_courses = @courses.select {|course| course.mini == "Both"}
  #  #@mini_a_courses = @courses.select {|course| course.mini == "A"}
  #  #@mini_b_courses = @courses.select {|course| course.mini == "B"}
  #  #
  #  #index_core
  #  index_for_semester
  #end
  #
  #def next_semester
  #  @all_courses = false
  #  @semester = AcademicCalendar.next_semester()
  #  @year = AcademicCalendar.next_semester_year()
  #
  #  @courses = Course.for_semester(@semester, @year)
  #  @semester_length_courses = @courses.select {|course| course.mini == "Both"}
  #  @mini_a_courses = @courses.select {|course| course.mini == "A"}
  #  @mini_b_courses = @courses.select {|course| course.mini == "B"}
  #
  #  index_core
  #end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find(params[:id])

    teams = Team.where(:course_id => params[:id])

    @emails = []
    teams.each do |team|
      team.people.each do |person|
        @emails << person.email
      end
    end

    @registered =

    @students = Hash.new
    @course.registered_students.each do |student|
      @students[student.human_name] = {:hub => true}
    end
    @course.teams.each do |team|
      team.people.each do |person|
        @students[person.human_name] = (@students[person.human_name] || Hash.new).merge({:team => true, :team_name => team.name})
      end
    end
    tmp = @students


    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    authorize! :create, Course
    @course = Course.new
    @course.semester = AcademicCalendar.next_semester
    @course.year = AcademicCalendar.next_semester_year

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @course }
    end
  end

  # GET /courses/1/edit
  def edit
    store_previous_location
    @course = Course.find(params[:id])
    authorize! :update, @course
  end

  def configure
    edit
  end

  # POST /courses
  # POST /courses.xml
  def create
    authorize! :create, Course
    @last_offering = Course.last_offering(params[:course][:number])
    if @last_offering.nil?
      @course = Course.new(:name => "New Course", :mini => "Both", :number => params[:course][:number])
    else
      @course = @last_offering.copy_as_new_course
    end

    @course.year = params[:course][:year]
    @course.semester = params[:course][:semester]

    respond_to do |format|
      @course.updated_by_user_id = current_user.id if current_user
      if @course.save

        flash[:notice] = 'Course was successfully created.'
        format.html { redirect_to edit_course_path(@course) }
        format.xml { render :xml => @course, :status => :created, :location => @course }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    @course = Course.find(params[:id])
    authorize! :update, @course

    if (params[:course][:is_configured]) #The previous page was configure action
      if params[:course][:curriculum_url].include?("info.sv.cmu.edu")
        @course.twiki_url = params[:course][:curriculum_url].sub("https", "http")
      end
      @course.configured_by_user_id = current_user.id
    end

    params[:course][:faculty_assignments_override] = params[:people]
    respond_to do |format|
      @course.updated_by_user_id = current_user.id if current_user
      @course.attributes = params[:course]
      if @course.save
        if (params[:course][:is_configured])
          #The previous page was configure action
          CourseMailer.configure_course_admin_email(@course).deliver
        else
          #The previous page was edit action
          CourseMailer.configure_course_faculty_email(@course).deliver unless @course.is_configured?
        end
        flash[:notice] = 'Course was successfully updated.'
        format.html { redirect_back_or_default(course_path(@course)) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @course.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.xml
  def destroy
    if has_permissions_or_redirect(:admin, root_path)
      @course = Course.find(params[:id])
      @course.destroy

      respond_to do |format|
        format.html { redirect_to(courses_url) }
        format.xml { head :ok }
      end
    end
  end

  def upload
    require 'HUB_class_roster_handler'

    authorize! :upload, Course
    store_previous_location
    file_content = params[:file].read()

    begin
      changes_applied = HUBClassRosterHandler::handle(file_content)
      if changes_applied
        flash[:notice] = 'Roster file was parsed and handled successfully.'
      else
        flash[:notice] = 'Roster file parsed successfully, but no changes made.'
      end
    rescue Exception => ex
      flash[:error] = "There was a problem parsing your roster file: #{ex.message}"
    end

    respond_to do |format|
      format.html { redirect_back_or_default(courses_path) }
    end
  end

  def team_formation_tool
    @course = Course.find(params[:course_id])
    authorize! :team_formation, @course

    respond_to do |format|
      format.html { render :html => @teams, :layout => "cmu_sv" } # index.html.erb
      format.xml { render :xml => @teams }
    end
  end


  def export_to_csv
    @course = Course.find(params[:course_id])
    authorize! :team_formation, @course

    report = CSV.generate do |title|
      title << ['Person', 'Current Team', 'Past Teams', "Part Time", "Local/Near/Remote", "Program", "State", "Company Name"]
      @course.registered_students.each do |user|
          current_team = @course.teams.collect {|team| team if team.users.include?(user) }.compact
          part_time = user.is_part_time ? "PT" : "FT"
          title << [user.human_name, user.formatted_teams(current_team), user.formatted_teams(user.past_teams), part_time, user.local_near_remote, user.masters_program + " " + user.masters_track, user.work_state, user.organization_name]
      end
    end
    send_data(report, :type=>'text/csv;charset=iso-8859-1;', :filename=>"past_teams_for_#{@course.display_course_name}.csv",
              :disposition =>'attachment', :encoding => 'utf8')
  end

  private
  def index_core
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @courses }
    end
  end
end
