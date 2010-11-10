class PeopleController < ApplicationController

  before_filter :require_user, :except => [:show_by_twiki]

# Floating box source: http://roshanbh.com.np/2008/07/top-floating-message-box-using-jquery.html

  layout 'cmu_sv'

  
#  auto_complete_for :person, :human_name
#  protect_from_forgery :only => [:create, :update, :destroy] #required for auto complete to work
  
  # GET /people
  # GET /people.xml
  def index
    criteria = ["graduation_year", "first_name", "last_name", "masters_program", "masters_track", "tigris", "skype", "email", "organization_name", "work_city", "work_state", "work_country", "is_staff", "is_student","is_admin", "is_active", "is_teacher", "is_teacher", "is_alumnus", "office", "telephone1", "personal_email", "local_near_remote", "is_adobe_connect_host", "is_part_time", :image_uri]
    conditions = {}
    criteria.each {|name| conditions[name] = params[name] if (params[name] && (params[name] != ''))}
    if !conditions[:image_uri].nil?
      conditions[:image_uri] = "/images/mascot.jpg"
    end

    if !conditions.empty?
      @people = Person.find(:all, :conditions => to_like_conditions(conditions))
    else
      @people = Person.find(:all, :conditions => ['is_active = ?', true],  :order => "first_name ASC, last_name ASC")
    end

    if params[:course_name] == ''
      class_name = nil
    else
      class_name = params[:course_name]
    end
    if params[:course_semester] == ''
      class_semester = nil
    else
      class_semester = params[:course_semester]
    end
    if params[:course_year] == ''
      class_year = nil
    else
      class_year = params[:course_year]
    end

   #print "current people size2 = " + @people.size().to_s
    if !(class_name.nil? && class_semester.nil? && class_year.nil?)
      #print "current people size3 = " + @people.size().to_s
      @people.each do |person|
        if !class_name.nil?
          @people.delete_if { |person|  !(find_course_per_person(person, class_semester, class_year).include? params[:course_name])}
        else
          @people.delete_if { |person|  find_course_per_person(person, class_semester, class_year) == ''}
        end
      end

    end
    @people
  end

    def to_like_conditions( conditions )

    like_conditions = []
    key_count = conditions.size
    k = ""
    conditions.each_key do |key|
      k += "#{key} LIKE ?"
      if key_count > 1
        k += " and "
      end
      key_count -= 1
    end
    like_conditions << k

    conditions.each_value do |value|
      like_conditions << "%#{value}%"
    end

    like_conditions

  end

  def phone_book
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
    if(params[:id].to_i == 0) #This is a string
      @person = Person.find_by_twiki_name(params[:id])
    else #This is a number
      @person = Person.find(params[:id])
    end
    @person.revert_to params[:version_id] if params[:version_id]

    if(@person && @person.papers.size > 0 )
      @show_my_papers_link = true
    end

    respond_to do |format|
      if @person.nil?
        flash[:error] = "Person with an id of #{params[:id]} is not in this system."
        format.html { redirect_to(people_url)  }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      else
        format.html # show.html.erb
        format.xml  { render :xml => @person }
      end
    end
  end

  # GET /people/twiki/AndrewCarnegie
  # GET /people/twiki/AndrewCarnegie.xml
  def show_by_twiki
    redirect_to :action => 'robots' if robot?
    host = get_http_host()
    if !(host.include?("info.sv.cmu.edu") || host.include?("info.west.cmu.edu")) && (current_user.nil?)
      flash[:error] = 'You don''t have permissions to view this data.'
      redirect_to(people_url)
      return
    end

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
#      @person.save
      @person.save_without_session_maintenance

      GenericMailer.deliver_email(
        :to => "help@sv.cmu.edu",
        :cc => "todd.sedano@sv.cmu.edu",
        :subject => "rails user account automatically created for #{twiki_name}",
        :message => "Action Required: update this user's andrew id in the rails database.<br/><br/>The twiki page for #{twiki_name} was rendered on the twiki server. This page asked rails to generate user data from the rails database. This user did not exist in the rails database, so rails created it.<br/>Note: this person can not edit their own information until their record is updated with their andrew login.<br/><br/>first_name: #{@person.first_name}<br/>last_name: #{@person.last_name}<br/>email: #{@person.email}<br/>is_active?: #{@person.is_active?}",
        :url_label => "Edit this person's information",
        :url => "http://rails.sv.cmu.edu" + edit_person_path(@person)
      )

    end

    if(@person && @person.papers.size > 0 )
      @show_my_papers_link = true
    end

    respond_to do |format|
      if @person.nil?
        flash[:error] = "Person #{params[:twiki_name]} is not in this system."
        format.html { redirect_to(people_url)  }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      else
        format.html { render :html => @person, :layout => false }# show.html.erb
        format.xml  { render :xml => @person }
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

     if development?
       @domain = GOOGLE_DOMAIN
     else
       @domain = "sv.cmu.edu"
     end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/1/edit
  def edit
#    if !(current_user.is_admin? || current_user.is_staff?)
#      flash[:error] = "You don't have permission to do this action."
#      redirect_to(people_url) and return
#    end

    @person = Person.find(params[:id])
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

#      if @person.save
      if @person.save_without_session_maintenance
         create_google_email =  params[:create_google_email]
         create_twiki_account = params[:create_twiki_account]
         create_yammer_account = params[:create_yammer_account]
         Delayed::Job.enqueue(PersonJob.new(@person.id, params[:create_google_email], params[:create_twiki_account], params[:create_yammer_account])) unless params[:create_google_email].nil? &&  params[:create_twiki_account].nil? &&  params[:create_yammer_account].nil?
#          job = PersonJob.new(@person.id, params[:create_google_email], params[:create_twiki_account]) unless params[:create_google_email].nil? &&  params[:create_twiki_account].nil?
#          job.perform

#        flash[:error] = error_message unless error_message.blank?

        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@person) }
        format.xml  { render :xml => @person, :status => :created, :location => @person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
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

    respond_to do |format|

#      if @person.save_without_session_maintenance
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @person.errors, :status => :unprocessable_entity }
      end
    end
  end

  def revert_to_version
    @person = Person.find( params[:id] )
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
      flash[:error] = 'You don''t have permission to do this action.'
      redirect_to(people_url) and return   
    end  
      
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end




  def my_teams
    @person = Person.find(params[:id])
    person_id = @person.id.to_i
    if (current_user.id != person_id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
      flash[:error] = 'You don''t have permission to see another person''s teams.'
      redirect_to(people_url) and return
      end
    end
    @course = Course.new()

    @current_year = Date.today.year()
    @current_semester = ApplicationController.current_semester()

    #SQL statements determined by Team Juran
    @current_teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND c.semester = ? AND c.year = ?", person_id, @current_semester, @current_year])
    @past_teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND (c.semester <> ? OR c.year <> ?)", person_id, @current_semester, @current_year])

    (@teams_map, @teams_students_map) = current_user.faculty_teams_map(person_id)
    a = 10
  end

  def find_course_per_person(person, semester, year)
    #SQL statements determined by Team Juran
    if !semester.nil? and !year.nil?
      teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND c.semester like ? AND c.year like ?", person.id.to_i, semester, year])
    elsif !semester.nil? and year.nil?
      teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND c.semester like ?", person.id.to_i, semester])
    elsif semester.nil? and !year.nil?
      teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND c.year like ?", person.id.to_i, year])
    else
      teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ?", person.id.to_i])
    end
    count = 0
    my_courses = ""
      teams_as_member.each do |team|
        team_course = Course.find_by_id(team.course_id)
          count = count + 1
          if count > 1
            my_courses.concat(", ")
          end
          my_courses.concat(team_course.name.to_s)
      end
    return my_courses
  end

end
