class TeamsController < ApplicationController
  before_filter :require_user, :except => [:index, :twiki_index, :twiki_new]
  require 'csv'

  layout 'cmu_sv'

#  auto_complete_for :user, :human_name
#  layout 'cmu_sv', :except => [:ajax_add_team_member, :ajax_remove_team_member]

  #  def ajax_add_team_member
#    @team = Team.find(params[:team_id])
#  rescue ActiveRecord::RecordNotFound
#    logger.error("Attempt to access invalid team #{params[:team_id]}")
#    flash[:notice] = 'Attempt to access invalid team'
#    redirect_to teams_url
#  else
#    @added_member = @team.add_person_by_human_name(params[:user][:human_name])
#    @course = Course.find(@team.course_id)
#    render :partial => "list_team_members", :object=> @team
#  end
#
#  def ajax_remove_team_member
#    @team = Team.find(params[:team_id])
#  rescue ActiveRecord::RecordNotFound
#    logger.error("Attempt to access invalid team #{params[:team_id]}")
#    flash[:notice] = 'Attempt to access invalid team'
#    redirect_to teams_url
#  else
#    @team.remove_person(params[:person_id])
#    @course = Course.find(@team.course_id)
#    render :partial => "list_team_members", :object=> @team
#  end


  def remove_team_member
    team = Team.find(params[:team_id])
    team.remove_person(params[:person_id])
    team.save

    render :layout=>false
  end

  # GET /courses/1/teams
  # GET /courses/1/teams.xml
  def index
    @show_teams_for_many_courses = false
    @machine_name = ""
    @teams = Team.find(:all, :order => "id", :conditions => ["course_id = ?", params[:course_id]]) unless params[:course_id].empty?
    @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])
    @course = Course.find(params[:course_id])                         

    @show_section = false
    @teams.each do |team|
      @show_section = true unless (team.section.nil? || team.section.empty?)
    end

    respond_to do |format|
      format.html { render :partial => "twiki_index", :layout => "teams", :locals => {:teams => @teams, :show_new_teams_link => true, :show_photo_view_link => true, :show_student_photos => false, :show_course => false} } # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # Create a new team from a team table page hosted on the twiki server
  def twiki_new
    # Example url:
    # http://info.sv.cmu.edu/twiki/bin/view/Fall2008/Foundations/StudentTeams
    # http://info.sv.cmu.edu/twiki/bin/view/Fall2009/Foundations/WebHome
    url = get_twiki_http_referer()
    @course = Course.find(:first, :conditions => ["twiki_url = ?", url])
    if(@course.nil?)
      parts = url.split('/')
      @course = Course.new()
      @course.twiki_url = url
      @course.name = parts[parts.length - 2]
      match = parts[parts.length - 3].match /(\D+)(\d+)/
      @course.semester = match[1] unless (match.nil? || match[1].nil?)
      @course.year = match[2] unless (match.nil? || match[2].nil?)
      @course.save()
    else
      #error
    end
    redirect_to url
  end

   # generate the team table for a course on a page hosted on the twiki server
   def twiki_index
    @show_teams_for_many_courses = false
    @machine_name = "http://rails.sv.cmu.edu"

     url = get_twiki_http_referer()
    @course = Course.find(:first, :conditions => ["twiki_url = ?", url])

    @show_create_course = false
    if(@course.nil?)
      @show_create_course = true
       render :partial => "twiki_index", :layout => false, :locals => {:teams => @teams, :show_new_teams_link => true, :show_photo_view_link => true, :show_student_photos => false, :show_course => false}
       return
    end
    @teams = Team.find(:all, :order => "id", :conditions => ["course_id = ?", @course.id]) unless @course.nil?

    @show_section = false
    @teams.each do |team|
      @show_section = true unless (team.section.nil? || team.section.empty?)
    end

    render :partial => "twiki_index", :layout => false, :locals => {:teams => @teams, :show_new_teams_link => true, :show_photo_view_link => true, :show_student_photos => false, :show_course => false}
  end

  def index_photos
    @teams = Team.find(:all, :order => "id", :conditions => ["course_id = ?", params[:course_id]]) unless params[:course_id].empty?
    @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])
    @course = Course.find(params[:course_id])

    respond_to do |format|
      format.html { render :html => @teams, :layout => "teams" } # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  def teams_list
    @teams = Team.find(:all, :order => "id", :conditions => ["course_id = ?", params[:course_id]]) unless params[:course_id].empty?
    @course = Course.find(params[:course_id])

    respond_to do |format|
      format.html { render :html => @teams, :layout => "teams" } # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /courses/1/teams
  # GET /courses/1/teams.xml
#  def index_rails
#    @teams = Team.find(:all, :conditions => ["course_id = ?", params[:course_id]]) unless params[:course_id].empty?
#    @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])
#    @course = Course.find(params[:course_id])
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @teams }
#    end
#  end

  # GET /teams
  # GET /teams.xml
  def index_all
    @show_teams_for_many_courses = true
    @show_create_course = false
    @show_section = false
    @machine_name = ""

    #If possible, we would prefer to do an order by in sql to sort latest semester alphabetical by course name.
    @teams = Team.find(:all, :order => "course_id DESC")
#    @teams = @teams.sort_by {|team| team.course.year + team.course.semester + team.course.name }.reverse

    respond_to do |format|
#      format.html { render :html => @teams, :layout => "teams" } # index.html.erb
      format.html { render :partial => "twiki_index", :layout => "teams", :locals => {:teams => @teams, :show_new_teams_link => false, :show_photo_view_link => false, :show_student_photos => false, :show_course => false} } # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end


  # GET /courses/1/teams/1
  # GET /courses/1/teams/1.xml
  def show
    @course = Course.find(params[:course_id])
    @team = Team.find(params[:id])



    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /courses/1/teams/new
  # GET /courses/1/teams/new.xml
  def new
    @team = Team.new
    @team.course_id = params[:course_id]
    @course = Course.find(params[:course_id])
    @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /courses/1/teams/1/edit
  def edit
    @team = Team.find(params[:id])
    @team.course_id = params[:course_id]
    @course = Course.find(params[:course_id])
    @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])
  end

  # POST /courses/1/teams
  # POST /courses/1/teams.xml
  def create
    msg = check_valid_names
    if !msg.empty?
      logger.debug msg
      flash[:error] = msg
      redirect_to :action => 'new'
      return
    end
    update_course_faculty_label

    @team = Team.new(params[:team])
    @team.course_id = params[:course_id]

    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(course_teams_path(@team.course_id)) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1/teams/1
  # PUT /courses/1/teams/1.xml
  def update
    @team = Team.find(params[:id])

    msg = check_valid_names
    if !msg.empty?
      logger.debug msg
      flash[:error] = msg
      redirect_to :action => 'update'
      return
    end
    handle_teams_people

    update_course_faculty_label

    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(course_teams_path(@team.course)) }
        format.xml  { head :ok }
      else
        @faculty = User.find(:all, :order => "twiki_name", :conditions => ["is_teacher = true"])
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1/teams/1
  # DELETE /courses/1/teams/1.xml
  def destroy
    if !current_user.is_admin?
      flash[:error] = 'You don''t have permission to do this action.'
      redirect_to(teams_url) and return
    end

    @team = Team.find(params[:id])
    course = @team.course
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(course_teams_path(course)) }
      format.xml  { head :ok }
    end
  end

  # GET /courses/1/teams/1/survey_monkey
  def survey_monkey
    @course = Course.find(params[:course_id])
    @team = Team.find(params[:id])

    @emails = []
    @first_names = []
    @full_names = []
    @ids = []
    @team.people.each do | person|
      @emails << person.email
      @first_names << person.first_name
      @full_names << person.human_name
      @ids << person.id
    end

    if(@team.peer_evaluation_first_email.nil?)
      @team.peer_evaluation_first_email = Time.now()
    end
    if(@team.peer_evaluation_second_email.nil?)
        @team.peer_evaluation_second_email = Time.now()
    end

    @first_email_date = @team.peer_evaluation_first_email.strftime("%Y%m%d")
    @second_email_date = @team.peer_evaluation_second_email.strftime("%Y%m%d")

    #    @first_email_date = @team.peer_evaluation_first_email.to_s.gsub('-','')
#    @second_email_date = @team.peer_evaluation_second_email.to_s.gsub('-','')

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  def survey_monkey_update
    @team = Team.find(params[:id])

    firstDate = params[:yearFieldOne] + "-" + params[:monthFieldOne] + "-" + params[:dayFieldOne]
    firstDate = firstDate.to_date

    secondDate = params[:yearFieldTwo] + "-" + params[:monthFieldTwo] + "-" + params[:dayFieldTwo]
    secondDate = secondDate.to_date

    @team.peer_evaluation_first_email = firstDate
    @team.peer_evaluation_second_email = secondDate
    @team.save!

    redirect_to(survey_monkey_path(@team.course, @team.id))
  end

   def export_to_csv
    @teams = Team.find(:all, :order => "id", :conditions => ["course_id = ?", params[:course_id]]) unless params[:course_id].empty?
    report = StringIO.new
    CSV::Writer.generate(report, ',') do |title|
      title << ['Team Name','Team Member','Past Teams']
        @teams.each do |team|
          team.people.each do |person|
            title << [team.name, person.human_name, find_past_teams(person)]
          end
        end
      end
    report.rewind
    send_data(report.read,:type=>'text/csv;charset=iso-8859-1;',:filename=>'report.csv',
    :disposition =>'attachment', :encoding => 'utf8')
  end

  def find_past_teams(person)
    @past_teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND (c.semester <> ? OR c.year <> ?)", person.id, ApplicationController.current_semester(), Date.today.year])

    teams_list = ""
    count = 0
    @past_teams_as_member.each do |team|
      if count == 0
        teams_list = team.name
      else
        teams_list = teams_list.concat(", " + team.name)
      end
      count += 1
    end
    return teams_list
  end


  private
  def check_valid_names
    error_msg = ""
    return error_msg
    if params[:team]['person_name']
         Person.find_by_human_name(params[:team][:person_name]) rescue error_msg = error_msg + params[:team][:person_name] + " "
    end
    if params[:team]['person_name2']
         Person.find_by_human_name(params[:team][:person_name2]) rescue error_msg = error_msg + params[:team][:person_name2] + " "
    end
    if params[:team]['person_name3']
         Person.find_by_human_name(params[:team][:person_name3]) rescue error_msg = error_msg + params[:team][:person_name3] + " "
    end
    if params[:team]['person_name4']
         Person.find_by_human_name(params[:team][:person_name4]) rescue error_msg = error_msg + params[:team][:person_name4] + " "
    end
    if params[:team]['person_name5']
         Person.find_by_human_name(params[:team][:person_name5]) rescue error_msg = error_msg + params[:team][:person_name5] + " "
    end
    if params[:team]['person_name6']
         Person.find_by_human_name(params[:team][:person_name6]) rescue error_msg = error_msg + params[:team][:person_name6] + " "
    end
    if !error_msg.empty?
        "Unable to find users with the name " + error_msg
    end
  end

  def handle_teams_people
    logger.debug("handle_teams_people()")
    if params['person_ids']
      logger.debug("**************")
      @team.people.clear
      people = params['person_ids'].map { |id| Person.find(id) }
      logger.debug("part 2")
      logger.debug(people)
      @team.people << people
    end
#  rescue
#    logger.debug "record not found"
  end

  def update_course_faculty_label
    @course = Course.find(params[:course_id])
    if @course.primary_faculty_label != params[:primary_faculty_label] || @course.secondary_faculty_label != params[:seconday_faculty_label] then
      @course.primary_faculty_label   = params[:primary_faculty_label]
      @course.secondary_faculty_label = params[:secondary_faculty_label]
      @course.save
    end
  end
end
