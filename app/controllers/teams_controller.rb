class TeamsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :twiki_index, :twiki_new]
  require 'csv'

  layout 'cmu_sv'

  # GET /courses/1/teams
  # GET /courses/1/teams.xml
  def index
    @show_teams_for_many_courses = false
    @machine_name = ""
    @teams = Team.where(:course_id => params[:course_id]).order("id").all unless params[:course_id].empty?
    @course = Course.find(params[:course_id])

    @show_section = false
    @teams.each do |team|
      @show_section = true unless (team.section.nil? || team.section.empty?)
    end

    respond_to do |format|
      format.html { render :partial => "twiki_index", :locals => {:teams => @teams, :show_new_teams_link => true, :show_photo_view_link => true, :show_student_photos => false, :show_course => false} } # index.html.erb
      format.xml { render :xml => @teams }
    end
  end

  # Create a new team from a team table page hosted on the twiki server
  def twiki_new
    if has_permissions_or_redirect(:staff, root_path)
      # Example url:
      # http://info.sv.cmu.edu/twiki/bin/view/Fall2008/Foundations/StudentTeams
      # http://info.sv.cmu.edu/twiki/bin/view/Fall2009/Foundations/WebHome
      url = get_twiki_http_referer()
      @course = Course.where(:twiki_url => url).first
      if (@course.nil?)
        parts = url.split('/')
        @course = Course.new()
        @course.twiki_url = url
        @course.name = parts[parts.length - 2]
        match = parts[parts.length - 3].match /(\D+)(\d+)/
        @course.semester = match[1] unless (match.nil? || match[1].nil?)
        @course.year = match[2] unless (match.nil? || match[2].nil?)

        if !@course.save()
          flash[:error] = 'Course could not be created.'
        end
      else
        #error
      end
      redirect_to url
    end
  end

  # generate the team table for a course on a page hosted on the twiki server
  def twiki_index
    @show_teams_for_many_courses = false
    @machine_name = "http://whiteboard.sv.cmu.edu"

    url = get_twiki_http_referer()
    @course = Course.where(:twiki_url => url).first

    @show_create_course = false
    if (@course.nil?)
      @show_create_course = true
      render :partial => "twiki_index", :layout => false, :locals => {:teams => @teams, :show_new_teams_link => true, :show_photo_view_link => true, :show_student_photos => false, :show_course => false}
      return
    end
    @teams = Team.where(:course_id => @course.id).order("id").all unless @course.nil?

    @show_section = false
    @teams.each do |team|
      @show_section = true unless (team.section.nil? || team.section.empty?)
    end

    render :partial => "twiki_index", :layout => false, :locals => {:teams => @teams, :show_new_teams_link => true, :show_photo_view_link => true, :show_student_photos => false, :show_course => false}
  end

  def index_photos
    @teams = Team.where(:course_id => params[:course_id]).order("id").all unless params[:course_id].empty?
    @course = Course.find(params[:course_id])

    respond_to do |format|
      format.html { render :html => @teams, :layout => "simple" } # index.html.erb
      format.xml { render :xml => @teams }
    end
  end

  def past_teams_list
    if has_permissions_or_redirect(:staff, root_path)
      @teams = Team.where(:course_id => params[:course_id]).order("id").all unless params[:course_id].empty?
      @course = Course.find(params[:course_id])

      respond_to do |format|
        format.html { render :html => @teams, :layout => "cmu_sv" } # index.html.erb
        format.xml { render :xml => @teams }
      end
    end
  end

  def export_to_csv
    if has_permissions_or_redirect(:staff, root_path)

      @course = Course.find(params[:course_id])
      @teams = Team.where(:course_id => params[:course_id]).order("id").all unless params[:course_id].empty?

      report = CSV.generate do |title|
        title << ['Team Name', 'Team Member', 'Past Teams', "Part Time", "Local/Near/Remote", "State", "Company Name"]
        @teams.each do |team|
          team.members.each do |user|
            part_time = user.is_part_time ? "PT" : "FT"
            title << [team.name, user.human_name, user.formatted(user.past_teams), part_time, user.local_near_remote, user.work_state, user.organization_name]
          end
        end
      end
      send_data(report, :type => 'text/csv;charset=iso-8859-1;', :filename => "past_teams_for_#{@course.display_course_name}.csv",
                :disposition => 'attachment', :encoding => 'utf8')
    end
  end


  # GET /teams
  # GET /teams.xml
  def index_all
    @show_teams_for_many_courses = true
    @show_create_course = false
    @show_section = false
    @machine_name = ""

    #If possible, we would prefer to do an order by in sql to sort latest semester alphabetical by course name.
    @teams = Team.order("course_id DESC").all
    #    @teams = @teams.sort_by {|team| team.course.year + team.course.semester + team.course.name }.reverse

    respond_to do |format|
      format.html { render :partial => "twiki_index", :locals => {:teams => @teams, :show_new_teams_link => false, :show_photo_view_link => false, :show_student_photos => false, :show_course => false} } # index.html.erb
      format.xml { render :xml => @teams }
    end
  end


  # GET /courses/1/teams/1
  # GET /courses/1/teams/1.xml
  def show
    @course = Course.find(params[:course_id])
    @team = Team.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @team }
    end
  end

  # GET /courses/1/teams/new
  # GET /courses/1/teams/new.xml
  def new
    if has_permissions_or_redirect(:staff, root_path)
      @team = Team.new()
      @team.course_id = params[:course_id]
      @course = Course.find(params[:course_id])
      @faculty = @course.faculty
      (1..5).each do
        @team.members << User.new
      end

      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @team }
      end
    end
  end

  # GET /courses/1/teams/1/edit
  def edit
    @team = Team.find(params[:id])
    @course = Course.find(params[:course_id])
    if has_permissions_or_redirect(:staff, course_team_path(@course, @team))
      @team.course_id = params[:course_id]
      @faculty = @course.faculty
    end
  end

  # POST /courses/1/teams
  # POST /courses/1/teams.xml
  def create
    if has_permissions_or_redirect(:staff, root_path)
      params[:team][:members_override] = params[:persons]
      @team = Team.new(params[:team])

      @team.course_id = params[:course_id]
      @course = Course.find(params[:course_id])

      update_course_faculty_label

      respond_to do |format|
        if @team.save
          flash[:notice] = 'Team was successfully created.'
          format.html { redirect_to(course_teams_path(@team.course_id)) }
          format.xml { render :xml => @team, :status => :created, :location => @team }
        else
          @faculty = @course.faculty
          format.html { render :action => "new" }
          format.xml { render :xml => @team.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /courses/1/teams/1
  # PUT /courses/1/teams/1.xml
  def update
    params[:team][:members_override] = params[:persons]
    @team = Team.find(params[:id])
    @course = @team.course
    if has_permissions_or_redirect(:staff, course_team_path(@course, @team))

      update_course_faculty_label

      respond_to do |format|
        @team.attributes = params[:team]
        if @team.save(params[:team])
          flash[:notice] = 'Team was successfully updated.'
          format.html { redirect_to(course_teams_path(@team.course)) }
          format.xml { head :ok }
        else
          @faculty = @course.faculty
          format.html { render :action => "edit" }
          format.xml { render :xml => @team.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /courses/1/teams/1
  # DELETE /courses/1/teams/1.xml
  def destroy
    if !current_user.is_admin?
      flash[:error] = I18n.t(:no_permission)
      redirect_to(teams_url) and return
    end

    @team = Team.find(params[:id])
    course = @team.course
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(course_teams_path(course)) }
      format.xml { head :ok }
    end
  end

  # GET /courses/1/teams/1/peer_evaluation
  def peer_evaluation
    @course = Course.find(params[:course_id])
    @team = Team.find(params[:id])

    @emails = []
    @first_names = []
    @full_names = []
    @ids = []
    @team.members.each do |user|
      @emails << user.email
      @first_names << user.first_name
      @full_names << user.human_name
      @ids << user.id
    end

    if (@team.peer_evaluation_first_email.nil?)
      @team.peer_evaluation_first_email = Date.today()
    end
    if (@team.peer_evaluation_second_email.nil?)
      @team.peer_evaluation_second_email = Date.today()
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @team }
    end
  end

  def peer_evaluation_update
    @team = Team.find(params[:id])

    @team.peer_evaluation_first_email = params[:team][:peer_evaluation_first_email]
    @team.peer_evaluation_second_email = params[:team][:peer_evaluation_second_email]

    if @team.save
      flash[:notice] = 'Dates saved'
    else
      flash[:error] = 'Dates not saved'
    end
    redirect_to(peer_evaluation_path(@team.course, @team.id))
  end


  def update_course_faculty_label
    @course = Course.find(params[:course_id])
    if @course.primary_faculty_label != params[:primary_faculty_label] || @course.secondary_faculty_label != params[:seconday_faculty_label] then
      @course.primary_faculty_label = params[:primary_faculty_label]
      @course.secondary_faculty_label = params[:secondary_faculty_label]
      @course.save
    end
  end
end
