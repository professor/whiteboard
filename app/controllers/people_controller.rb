class PeopleController < ApplicationController

  before_filter :authenticate_user!, :except => [:show_by_twiki]

# Floating box source: http://roshanbh.com.np/2008/07/top-floating-message-box-using-jquery.html

  layout 'cmu_sv'

#  auto_complete_for :person, :human_name
#  protect_from_forgery :only => [:create, :update, :destroy] #required for auto complete to work

# GET /people
# GET /people.xml
  def index
    if params[:term] #Ajax call for autocomplete
                     #if database is mysql
                     #@people = Person.find(:all, :conditions => ['human_name LIKE ?', "%#{params[:term]}%"])
      @people = Person.find(:all, :conditions => ['human_name ILIKE ?', "%#{params[:term]}%"])
    else
      @people = Person.find(:all, :conditions => ['is_active = ?', true], :order => "first_name ASC, last_name ASC")
    end


    respond_to do |format|
      format.html { render :html => @people }
      format.json { render :json => @people.collect { |person| person.human_name }, :layout => false }
    end
  end

  def advanced
    index
  end

  def photo_book
    index
  end


  # GET /people/1
  # GET /people/1.xml
  # GET /people/AndrewCarnegie
  # GET /people/AndrewCarnegie.xml
  def show
    if (params[:id].to_i == 0) #This is a string
      @person = Person.find_by_twiki_name(params[:id])
    else #This is a number
      @person = Person.find(params[:id])
    end
    @person.revert_to params[:version_id] if params[:version_id]

    respond_to do |format|
      if @person.nil?
        flash[:error] = "Person with an id of #{params[:id]} is not in this system."
        format.html { redirect_to(people_url) }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      else
        format.html # show.html.erb
        format.xml { render :xml => @person }
      end
    end
  end

  # GET /people/twiki/AndrewCarnegie
  # GET /people/twiki/AndrewCarnegie.xml
  def show_by_twiki
    redirect_to :action => 'robots' if robot?
    host = get_http_host()
    if !(host.include?("info.sv.cmu.edu") || host.include?("info.west.cmu.edu")) && (current_user.nil?)
      flash[:error] = 'You don' 't have permissions to view this data.'
      redirect_to(people_url)
      return
    end

    @machine_name = "http://rails.sv.cmu.edu"

    twiki_name = params[:twiki_name]
    @person = Person.find_by_twiki_name(twiki_name)

    if @person.nil?
      @person = Person.new
      @person.twiki_name = twiki_name
      names = Person.parse_twiki(twiki_name)
      @person.first_name = names[0] unless names.nil?
      @person.last_name = names[1] unless names.nil?
      @person.webiso_account = Time.now.to_f.to_s #This line probably not necessary since I added it to Person.before_validation
      @person.is_active = true
      @person.updated_by_user_id = current_user.id if current_user
      @person.image_uri = "/images/mascot.jpg"
      @person.local_near_remote = "Unknown"
      @person.save

      options = {:to => "help@sv.cmu.edu", :cc => "todd.sedano@sv.cmu.edu",
                 :subject => "rails user account automatically created for #{twiki_name}",
                 :message => "Action Required: update this user's andrew id in the rails database.<br/><br/>The twiki page for #{twiki_name} was rendered on the twiki server. This page asked rails to generate user data from the rails database. This user did not exist in the rails database, so rails created it.<br/>Note: this person can not edit their own information until their record is updated with their andrew login.<br/><br/>first_name: #{@person.first_name}<br/>last_name: #{@person.last_name}<br/>email: #{@person.email}<br/>is_active?: #{@person.is_active?}",
                 :url_label => "Edit this person's information",
                 :url => "http://rails.sv.cmu.edu" + edit_person_path(@person)
      }
      GenericMailer.email(options).deliver
    end

    respond_to do |format|
      if @person.nil?
        flash[:error] = "Person #{params[:twiki_name]} is not in this system."
        format.html { redirect_to(people_url) }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      else
        format.html { render :html => @person, :layout => false } # show.html.erb
        format.xml { render :xml => @person }
      end
    end
  end


  # GET /people/new
  # GET /people/new.xml
  def new
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(people_url) and return
    end

    @person = Person.new
    @person.is_active = true

    if Rails.env.development?
      @domain = GOOGLE_DOMAIN
    else
      @domain = "sv.cmu.edu"
    end

    @strength_themes = StrengthTheme.all


    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
#    if !(current_user.is_admin? || current_user.is_staff?)
#      flash[:error] = "You don't have permission to do this action."
#      redirect_to(people_url) and return
#    end

    @person = Person.find(params[:id])
    @strength_themes = StrengthTheme.all
  end

  # POST /people
  # POST /people.xml
  def create
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(people_url) and return
    end

    @person = Person.new(params[:person])
    @person.updated_by_user_id = current_user.id
    @person.image_uri = "/images/mascot.jpg"
    @person.biography = "<p>I was raised by sheepherders on the hills of BoingBoing while they were selling chunky bacon. Because I have a ring, I need help with putting on my clothes. After working hard they promoted me to garbage man. They told me the reason for this new responsibility was show me the money. I looked for a treasure map and tools, but I never did find the fourteen minutes. People's trash clearly isn't multitudinous. I hope to put my real biography here one day.</p>"
    if @person.is_student
      @person.user_text = "<h2>About Me</h2><p>I'd like to accomplish the following three goals (professional or personal) by the time I graduate:<ol><li>Goal 1</li><li>Goal 2</li><li>Goal 3</li></ol></p>"
    end


    respond_to do |format|

#      error_message = ""
#      if params[:create_google_email]
#         password = 'just4now' + Time.now.to_f.to_s[-4,4] # just4now0428
#         status = @person.create_google_email(password)
#         if status.is_a?(String)
#           error_message += "Google account not created. " + status + "</br></br>"
#         else
#          send_email([@person.personal_email, @person.email], @person.email, generate_message(@person, password))
#         end
#      end
#      if params[:create_twiki_account]
#        status = @person.create_twiki_account
#        error_message +=  'TWiki account was not created.<br/></br>' unless status
#        status = @person.reset_twiki_password
#        error_message +=  'TWiki account password was not reset.</br>' unless status
#      end

      if @person.save
        create_google_email = params[:create_google_email]
        create_twiki_account = params[:create_twiki_account]
        create_yammer_account = false #params[:create_yammer_account]
        Delayed::Job.enqueue(PersonJob.new(@person.id, params[:create_google_email], params[:create_twiki_account], params[:create_yammer_account])) unless params[:create_google_email].nil? && params[:create_twiki_account].nil? && params[:create_yammer_account].nil?
                                      #          job = PersonJob.new(@person.id, params[:create_google_email], params[:create_twiki_account]) unless params[:create_google_email].nil? &&  params[:create_twiki_account].nil?
                                      #          job.perform

                                      #        flash[:error] = error_message unless error_message.blank?

        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
#    if !(current_user.is_admin? || current_user.is_staff?)
#      flash[:error] = 'You don''t have permission to do this action.'
#      redirect_to(people_url) and return
#    end

    @person = Person.find(params[:id])
    @person.updated_by_user_id = current_user.id
    @strength_themes = StrengthTheme.all

    respond_to do |format|

#      if @person.save_without_session_maintenance
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def revert_to_version
    @person = Person.find(params[:id])
    @person.revert_to! params[:version_id]
    redirect_to :action => 'show', :id => @person
  end

  def robots
    logger.info("curriculum comment: robot detected")
    format.html # index.html.erb
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    if !current_user.is_admin?
      flash[:error] = 'You don' 't have permission to do this action.'
      redirect_to(people_url) and return
    end

    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml { head :ok }
    end
  end


  def my_teams
    @person = Person.find(params[:id])
    person_id = @person.id.to_i
    if (current_user.id != person_id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
        flash[:error] = 'You don' 't have permission to see another person' 's teams.'
        redirect_to(people_url) and return
      end
    end
    @course = Course.new()

    @current_year = Date.today.year()
    @current_semester = AcademicCalendar.current_semester()

    #SQL statements determined by Team Juran
    @current_teams_as_member = Team.find_current_by_person(@person)
    @past_teams_as_member = Team.find_past_by_person(@person)

    (@teams_map, @teams_students_map) = current_user.faculty_teams_map(person_id)
    a = 10
  end

  def my_courses
    @person = Person.find(params[:id])
    person_id = @person.id.to_i
    if (current_user.id != person_id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
        flash[:error] = 'You don' 't have permission to see another person' 's courses.'
        redirect_to(people_url) and return
      end
    end
    @registered_for_these_courses = [] #@person.registered_for_these_courses
    @teaching_these_courses = @person.teaching_these_courses
  end

  def my_courses_verbose
    @person = Person.find(params[:id])
    person_id = @person.id.to_i
    if (current_user.id != person_id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
        flash[:error] = 'You don' 't have permission to see another person' 's courses.'
        redirect_to(people_url) and return
      end
    end
    @courses_registered_as_student = @person.registered_for_these_courses_during_current_semester
    @courses_teaching_as_faculty = @person.teaching_these_courses
  end


  class ClassProfileState
    attr_accessor :graduation_year, :is_part_time, :program
  end


  def class_profile
    if params[:class_profile_state]
      @class_profile_state = ClassProfileState.new
      @class_profile_state.program = params[:class_profile_state][:program]
      @class_profile_state.graduation_year = params[:class_profile_state][:graduation_year]
      @class_profile_state.is_part_time = params[:class_profile_state][:is_part_time]
    else
      @class_profile_state = ClassProfileState.new
      @class_profile_state.program = current_user.is_student ? current_user.masters_program : "SE"
      @class_profile_state.graduation_year = Date.today.year + 1
      @class_profile_state.is_part_time = current_user.is_student && !current_user.is_part_time ? "FT" : "PT"
    end

    case @class_profile_state.is_part_time
      when "PT"
        @students = Person.part_time_class_of(@class_profile_state.program, @class_profile_state.graduation_year.to_s)
      when "FT"
        @students = Person.full_time_class_of(@class_profile_state.program, @class_profile_state.graduation_year.to_s)
    end
    @programs = []
    ActiveRecord::Base.connection.execute("SELECT distinct masters_program FROM users u;").each do |result|
      @programs << result["masters_program"]
    end
    @tracks = []
    ActiveRecord::Base.connection.execute("SELECT distinct masters_track FROM users u;").each do |result|
      @tracks << result["masters_track"]
    end

    @title = "Class profile for #{@class_profile_state.is_part_time} #{@class_profile_state.program} #{@class_profile_state.graduation_year}"

    respond_to do |format|
      if params[:layout]
        format.html { render :layout => false } # index.html.erb
      else
        format.html { render :layout => "cmu_sv" } # index.html.erb
      end
    end
  end

end
