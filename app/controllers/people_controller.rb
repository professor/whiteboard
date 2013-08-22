require 'csv'
require 'vpim/vcard'

class PeopleController < ApplicationController
  include ActionView::Helpers::AssetTagHelper

  def controller;
    self;
  end

  ; private(:controller)

  before_filter :authenticate_user!, :except => [:show_by_twiki]

# Floating box source: http://roshanbh.com.np/2008/07/top-floating-message-box-using-jquery.html

  layout 'cmu_sv'

#  auto_complete_for :person, :human_name
#  protect_from_forgery :only => [:create, :update, :destroy] #required for auto complete to work


  # GET /people
  # GET /people.xml
  #
  # 1. This method checks to see if the logged in user has entered sufficient information in his own profile
  #    to use the people_search functionality (lovingly called carrot & stick)
  # 2. This method loads the search bar and default/key contacts for that user.
  #
  def index
    # 1. carrot & stick
    if !current_user.is_profile_valid?
      flash[:notice] = "<div align='center'><b>Warning:</b><br/> You have to update your profile details.<br/> If you do not do so in 4 weeks, you will lose access to the search profile features.<br/><a href='#{url_for(edit_person_path(current_user))}'>Click here to edit your profile.</a></div>".html_safe
      flash[:error] = nil
      if current_user.should_be_redirected?
        flash[:notice] = nil
        flash[:error] = "<div align='center'><b>Warning:</b><br/> Your access to the user search features have temporarily been disabled. <br/>To continue, please update your biography/phone numbers and social handles.</div>".html_safe
       redirect_to edit_person_path(current_user) and return
      end
    end

    # 2. default/key contacts for that user
    @people = get_default_key_contacts
    # pick only the fields required to be shown in the view and return as a Hash
    @key_contact_results = @people.collect { |default_person| Hash[
        :image_uri => image_path(default_person.user.image_uri),
        :title => default_person.user.title,
        :human_name => default_person.user.human_name,
        :contact_dtls => default_person.user.telephones_hash,
        :email => default_person.user.email,
        :path => person_path(default_person.user),
        # first_name and last_name required for photobook view
        :first_name => default_person.user.first_name,
        :last_name => default_person.user.last_name
    ]}
    @key_contact_results.uniq!
    respond_to do |format|
      format.html { render :html => @key_contact_results }
      format.json { render :json => @key_contact_results }
    end
  end
  def advanced
    index
  end
  def photo_book
    index
  end

  # GET /people_search.json
  #
  # Ajax call for people search results using params[:filterBoxOne].
  # Sends back json object with search results (from database)
  #
  # Number of requesting coming in here is controlled through a javascript timer
  # (see js in views/people/index.html.erb for more details.)
  def search
    # call the function that actually finds all releveant search results from database
    @people = search_db_fields
    #
    priority_results = prioritize_search_results

    # pick only the fields required to be shown in the view and return as a Hash
    @people_hash = @people.collect do |person|
      # program, the user is enrolled in needs to be constructed to include addtional info like full-time/part-time
      program = ''
      if person.is_student
        program += (person.masters_program + ' ') unless person.masters_program.blank?
        program += person.masters_track unless person.masters_track.blank?
        if person.is_part_time
          program += ' (PT)'
        else
          program += ' (FT)'
        end
      elsif person.is_staff
        program += 'Staff'
      end
      # constructing Hash/json containing results
      Hash[:id => person.twiki_name,
           :first_name => person.first_name,
           :last_name => person.last_name,
           :image_uri => image_path(person.image_uri),
           :program => program,
           :contact_dtls => person.telephones_hash.map { |k,v| "#{k}: #{v}" }.to_a,
           :email => person.email,
           :path => person_path(person),
           :priority => priority_results.include?(person.id)
      ]
    end

    respond_to do |format|
      format.json { render :json =>  @people_hash, :layout => false }
    end
  end

  #Ajax call for autocomplete using params[:term]
  def index_autocomplete
    #if database is mysql
    #@people = User.where("human_name LIKE ?", "%#{params[:term]}%").all
    @people = User.where("human_name ILIKE ?", "%#{params[:term]}%").all

    respond_to do |format|
      format.html { render :html => @people }
      format.json { render :json => @people.collect { |person| person.human_name }, :layout => false }
    end
  end

  # GET /people/1
  # GET /people/1.xml
  # GET /people/AndrewCarnegie
  # GET /people/AndrewCarnegie.xml
  def show
    @person = Person.find_by_param(params[:id])
    @person.revert_to params[:version_id] if params[:version_id]

    respond_to do |format|
      if @person.nil?
        flash[:error] = "Person with an id of #{params[:id]} is not in this system."
        format.html { redirect_to(people_url) }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      else
        format.html # show.html.erb
        format.xml { render :xml => @person }
        format.json { render :json => @person, :layout => false }
      end
    end
  end

  # GET /people/twiki/AndrewCarnegie
  # GET /people/twiki/AndrewCarnegie.xml
  def show_by_twiki

    redirect_to :action => 'robots' if robot?
    host = get_http_host()
    if !(host.include?("info.sv.cmu.edu") || host.include?("info.west.cmu.edu")) && (current_user.nil?)
      flash[:error] = "You don't have permissions to view this data."
      redirect_to(people_url)
      return
    end

    @machine_name = "http://whiteboard.sv.cmu.edu"

    twiki_name = params[:twiki_name]
    @person = User.find_by_twiki_name(twiki_name)

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

  #http://localhost:3000/people/new?first_name=Todd&last_name=Sedano&webiso_account=at33@andrew.cmu.edu&is_student=true&program=ECE&expires_at=2013-01-01

  # GET /people/new
  # GET /people/new.xml
  def new
    authorize! :create, User

    @person = User.new
    @person.is_active = true
    @person.webiso_account = params[:webiso_account]
    @person.personal_email = params[:personal_email]
    @person.is_student = params[:is_student]
    @person.is_staff = params[:is_staff]
    @person.first_name = params[:first_name]
    @person.last_name = params[:last_name]
    @person.masters_program = params[:program]
    @person.expires_at = params[:expires_at]

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
    @person = User.find_by_param(params[:id])

    unless @person.id == current_user.id or current_user.is_admin?
      flash[:error] = "You're not allowed to edit this user's profile."
      redirect_to user_path(@person)
    end
#    authorize! :update, @person

    @strength_themes = StrengthTheme.all
  end

  # POST /people
  # POST /people.xml
  def create
    authorize! :create, User

    @person = User.new(params[:user])
    @person.updated_by_user_id = current_user.id
    @person.image_uri = "/images/mascot.jpg"
    @person.image_uri_first = "/images/mascot.jpg"
    @person.image_uri_second = "/images/mascot.jpg"
    @person.image_uri_custom = "/images/mascot.jpg"
    @person.photo_selection = "first"

    respond_to do |format|

      if @person.save
        create_google_email = params[:create_google_email]
        create_twiki_account = params[:create_twiki_account]
        create_active_directory_account = params[:create_active_directory_account]

        Delayed::Job.enqueue(PersonJob.new(@person.id, create_google_email, create_twiki_account, create_active_directory_account)) unless create_google_email.nil? && create_twiki_account.nil? && create_active_directory_account.nil?

        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def upload_photo
    @person = User.find_by_param(params[:id])
    if (can? :upload_official_photo, User) && !params[:user][:photo_first].blank?
      @person.photo_first = params[:user][:photo_first]
    end
    if (can? :upload_official_photo, User) && !params[:user][:photo_second].blank?
      @person.photo_second = params[:user][:photo_second]
    end

    if !params[:user][:photo_custom].blank?
      @person.photo_custom = params[:user][:photo_custom]
    end
    @person.attributes = params[:user]

    respond_to do |format|
      if @person.save
        format.html { redirect_to edit_person_path(@person) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = User.find_by_param(params[:id])
    # authorize! :update, @person

    Rails.logger.info("People#update #{request.env["REQUEST_PATH"]} #{current_user.human_name} #{params}")

    @person.updated_by_user_id = current_user.id
    @strength_themes = StrengthTheme.all

    respond_to do |format|
      @person.attributes = params[:user]
      @person.expires_at = params[:user][:expires_at] if current_user.is_admin?

      if @person.save
        unless @person.is_profile_valid
          flash[:error] = "Please update your (social handles or biography) and your contact information"
        end
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Checks whether the specified webiso account already exists.
  # Expected input is through the q=<account@andrew.cmu.edu> parameter
  # Output is an object with a single exists property set to whether the account
  # exists.
  # Requires user to be able to authenticate same-as-if creating.
  # GET /people/check_webiso_account
  def ajax_check_if_webiso_account_exists
    respond_with_existence User.find_by_webiso_account(params[:q])
  end

  # Checks whether the specified email account already exists.
  # Expected input is through the q=<account@andrew.cmu.edu> parameter
  # Output is an object with a single exists property set to whether the account
  # exists.
  # Requires user to be able to authenticate same-as-if creating.
  # GET /people/check_email
  def ajax_check_if_email_exists
    respond_with_existence User.find_by_email(params[:q])
  end

  # Creates a response from the specified object.
  # Output is an object with a single exists property set to whether the object
  # is not nil.
  def respond_with_existence obj
    result = {}
    result[:exists] = !obj.nil?

    respond_to do |format|
      format.json { render :json => result }
      format.xml { render :xml => result, :status => 200 }
    end
  end

  def revert_to_version
    @person = User.find_by_param(params[:id])
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

    @person = User.find_by_param(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml { head :ok }
    end
  end


  def my_teams
    @person = User.find_by_param(params[:id])
    if @person.nil?
      flash[:error] = "Person with an id of #{params[:id]} is not in this system."
      redirect_to(people_url) and return
    end

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
    @person = User.find_by_param(params[:id])
    if @person.nil?
      flash[:error] = "Person with an id of #{params[:id]} is not in this system."
      redirect_to(people_url) and return
    end

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
    @person = User.find_by_param(params[:id])
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
        @students = User.part_time_class_of(@class_profile_state.program, @class_profile_state.graduation_year.to_s)
      when "FT"
        @students = User.full_time_class_of(@class_profile_state.program, @class_profile_state.graduation_year.to_s)
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

  # GET /people/download_csv
  #
  # Export the search results in csv format
  def download_csv
    if params[:search_id].blank?
        # this is for multiple contacts
        @people = get_search_or_key_contacts(params)
    else
        # this is for a single contact
        @people = []
        @people << User.find_by_id(params[:search_id])
    end
    respond_to do |format|
      format.csv do
        csv_string = CSV.generate do |csv|
          csv << ["Name","Given Name","Additional Name","Family Name","Yomi Name","Given Name Yomi","Additional Name Yomi","Family Name Yomi","Name Prefix","Name Suffix","Initials","Nickname","Short Name","Maiden Name","Birthday","Gender","Location","Billing Information","Directory Server","Mileage","Occupation","Hobby","Sensitivity","Priority","Subject","Notes","Group Membership","E-mail 1 - Type","E-mail 1 - Value","E-mail 2 - Type","E-mail 2 - Value","Phone 1 - Type","Phone 1 - Value","Phone 2 - Type","Phone 2 - Value","Phone 3 - Type","Phone 3 - Value","Phone 4 - Type","Phone 4 - Value","Organization 1 - Type", "Organization 1 - Name", "Organization 1 - Yomi Name", "Organization 1 - Title", "Organization 1 - Department", "Organization 1 - Symbol", "Organization 1 - Location", "Organization 1 - Job Description"]
          @people.each do |user|
            org = user.organization_name.nil? ? "" : user.organization_name
            title = user.title.nil? ? "" : user.title
            csv << [user.first_name,user.first_name,"",user.last_name,"","","","","","","","","","","","","","","","","","","","","","","",user.is_staff? ? "Work" : "Other",user.email,"Home",user.personal_email,

                csv_name_converter(user.telephone1_label),user.telephone1,
                csv_name_converter(user.telephone2_label),user.telephone2,
                csv_name_converter(user.telephone3_label),user.telephone3,
                csv_name_converter(user.telephone4_label),user.telephone4,
                "",org,"",title,"","","",""]
          end
        end
        send_data csv_string,
                  :type=>"text/csv; charset=utf-8",
                  :disposition =>"attachment; filename=contact.csv"
      end
    end
  end

  # GET /people/download_vcf
  #
  # Export the search results in vCard format
  def download_vcf
    if params[:search_id].blank?
        # this is for multiple contacts
        @people = get_search_or_key_contacts(params)
    else
        # this is for a single contact
        @people = []
        @people << User.find_by_id(params[:search_id])
    end
    vcard_str=""
    @people.each do |user|
      card = Vpim::Vcard::Maker.make2 do |maker|
        maker.add_name do |name|
          name.prefix = ''
          name.given = user.first_name
          name.family = user.last_name
        end
        phones_hash = user.telephones_hash
        if(!user.email.blank?)
          maker.add_email(user.email) { |e| e.location = user.is_staff? ? 'work' : 'other' }
        end
        if(!user.personal_email.blank?)
          maker.add_email(user.personal_email) { |e| e.location = 'home' }
        end
        maker.title = user.title unless user.title.nil?
        maker.org = user.organization_name unless user.organization_name.nil?

        phones_hash.each do |k,v|
        # ignore empty telephone fields
          if(!v.blank?)
            maker.add_tel(v) do |tel|
              tel.location = "work" if k == "Work"
              tel.location = "home" if k == "Home"
              tel.location = "fax" if k == "Fax"
              tel.location = "cell" if k == "Mobile"
              tel.location = "voice" if k == "Google Voice"
            end
          end
        end
      end
      vcard_str << card.to_s
    end
    send_data vcard_str,
              :type=>"text/vcf; charset=utf-8",
              :disposition =>"attachment; filename=contact.vcf"
  end

  private

  # Private function that does the heavy lifting for all search
  #
  # search params:
  #     user_type
  #         F => Faculty
  #         S => Students
  #         T => Staff
  #         P => Part Time students
  #         L => Full Time students
  #         (can be clubbed e.g. SL for Full time students)
  #     filterBoxOne
  #         keywords typed in the search box
  #     graduation_year
  #     masters_program
  #     is_active
  def search_db_fields
    people = User.scoped

    # check user_type
    if !params[:user_type].blank?
        where_clause_string = ""
        if params[:user_type].include? "F" or params[:user_type].include? "S"  or params[:user_type].include? "T"
        # if (params[:user_type] =~ /[FST]/) == 0
            where_clause_string << "("
            where_clause_string << " is_faculty = 't' OR " if params[:user_type].include?("F")
            where_clause_string << " is_student = 't' OR " if params[:user_type].include?("S")
            where_clause_string << " is_staff = 't' OR " if params[:user_type].include?("T")
            # remove last OR
            where_clause_string= where_clause_string[0..-4]
            where_clause_string << ")"
        end
        people = people.where(where_clause_string) unless where_clause_string.blank?
        # user_type - P => Part Time students
        people = people.where("is_part_time = 't'") if params[:user_type].include?("P")
        # user_type - L => Full Time students
        people = people.where("is_part_time = 'f'") if params[:user_type].include?("L")
    end

    # search more db fields (checks all entered keywords with db fields)
    if !params[:filterBoxOne].blank?
      params[:filterBoxOne].split.each do |query|
        query = "%#{query}%"
        people = people.where( "first_name ILIKE ? OR last_name ILIKE ? OR human_name ILIKE ? OR biography ILIKE ? OR email ILIKE ? OR title ILIKE ? OR webiso_account ILIKE ? OR organization_name ILIKE ? OR personal_email ILIKE ? OR work_city ILIKE ? OR work_state ILIKE ? OR work_country ILIKE ?",query, query, query, query, query,query,query, query, query, query, query,query)
      end
    end

    # advanced search filter parameters
    people = people.where("graduation_year = ?","#{params[:graduation_year]}") unless params[:graduation_year].blank?
    people = people.where("masters_program = ?","#{params[:masters_program]}") unless params[:masters_program].blank?
    people = people.where("is_active = 't'") unless params[:search_inactive] == 't'
    people = people.joins(:registrations).where("registrations.course_id=?","#{params[:course_id]}") unless params[:course_id].blank?
#    people = people.joins(:teams).where("teams.course_id=?","#{params[:course_id]}") unless params[:course_id].blank?
    people = people.order("first_name ASC, last_name ASC")
  end

  # helper function that prioritizes the search results (if name was entered as part of search result, that is shown first vs it being found in bio/profile etc)
  def prioritize_search_results
    priority_results = User.scoped
    if !params[:filterBoxOne].blank?
      params[:filterBoxOne].split.each do |query|
        query = '%'+query+'%'
        priority_results = priority_results.where( "first_name ILIKE ? OR last_name ILIKE ? OR human_name ILIKE ? OR organization_name ILIKE ?",query, query, query, query)
      end
    end
    priority_results = priority_results.collect{ |result| result.id }
  end

  # Private function to get the key_contacts for a logged in user
  # (lovingly called group_box)
  def get_default_key_contacts
    @user = current_user
    if (current_user.is_admin? || current_user.is_staff?)
      if !params[:id].blank?
        @user_override = true
        @user = User.find_by_param(params[:id])
      end
    end
    results = PeopleSearchDefault.default_search_results(@user)
  end

  # Private helper function currently used by download_vcf and download_csv
  # to decide whether to return key_contacts or search_results from the search_params
  def get_search_or_key_contacts(search_params)
    if !search_params[:filterBoxOne].blank? || !search_params[:advanced_search_toggled].blank?
        # a specific search was issued, so return the exact search results for exporting contact details
        search_db_fields
    else
        # no specific search issues, return key_contact results
        @defaults = get_default_key_contacts
        @people = []
        @defaults.each do |default|
            @people << User.find(default.user_id)
        end
        return @people.uniq
    end
  end

  # private helper function to get correct keyname mappings for csv
  def csv_name_converter(origin)
    case origin
      when "Work"
        return "work"
      when "Home"
        return "home"
      when "Fax"
        return "fax"
      when "Mobile"
        return "cell"
      when "Google Voice"
        return "voice"
      else
        return ""
    end
  end

end
