class PeopleController < ApplicationController

  before_filter :require_user, :except => [:show_by_twiki]

# Floating box source: http://roshanbh.com.np/2008/07/top-floating-message-box-using-jquery.html

  layout 'cmu_sv'

  
#  auto_complete_for :person, :human_name
#  protect_from_forgery :only => [:create, :update, :destroy] #required for auto complete to work
  
  # GET /people
  # GET /people.xml
  def index
    if params[:search]
          @people = Person.find(:all, :conditions => ['human_name LIKE ?', "%#{params[:search]}%"])
    else
          @people = Person.find(:all, :conditions => ['is_active IS TRUE'],  :order => "first_name ASC, last_name ASC")
    end
      
    respond_to do |format|
#      format.html # index.html.erb
      format.html { render :html => @people, :layout => "cmu_sv" } # index.html.erb
      format.js   { render :js => @people, :layout => false }
      format.xml  { render :xml => @people }
    end
  end

  def phone_book
    index
  end

  def photo_book
    index
  end


  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])
    @person.revert_to params[:version_id] if params[:version_id]

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
      @person.image_uri = "/images/students/mascot.jpg"
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
    @person.image_uri = "/images/students/mascot.jpg"

    respond_to do |format|

      error_message = ""
      if params[:create_google_email]
         password = 'just4now' + Time.now.to_f.to_s[-4,4] # just4now0428
         status = @person.create_google_email(password)
         if status.is_a?(String)
           error_message += "Google account not created. " + status + "</br></br>"
         else
          send_email([@person.personal_email, @person.email], @person.email, generate_message(@person, password))
         end
      end
      if params[:create_twiki_account]
        status = @person.create_twiki_account
        error_message +=  'TWiki account was not created.<br/></br>' unless status
        status = @person.reset_twiki_password
        error_message +=  'TWiki account password was not reset.</br>' unless status
      end

#      if @person.save
      if @person.save_without_session_maintenance
        flash[:error] = error_message unless error_message.blank?

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

  private
  def send_email(personal_email, sv_email, message)
           GenericMailer.deliver_email(
             :bcc => "todd.sedano@sv.cmu.edu",
             :to => personal_email,
             :subject => "Welcome to Carnegie Mellon Silicon Valley (" + sv_email + ")",
             :message => message,
#             :url_label => "Check your email",
#             :url => "http://mail.google.com/a/west.cmu.edu/#inbox",
             :cc => "help@sv.cmu.edu"
            )
  end

  def generate_message(person,password)
   message =<<MESSAGE
<b>Welcome to Carnegie Mellon University's Silicon Valley Campus.</b><br/><br/>
Hi #{person.first_name},<br/><br/>
This email provides you with detailed information regarding your Silicon Valley email account, along with important information that ensures that you're connected to all Carnegie Mellon resources and information via this email account.<br/>
<br/>
<b>Silicon Valley email</b><br/>
Your Silicon Valley email account is your primary email account for all Silicon Valley academic and administrative communications. <i>We ask for all Silicon Valley community members to check their Silicon Valley email account <u>every business day.</u></i>
<ul><li>Your new email address is #{person.email}</li>
<li>Your temporary password is #{password}</li>
<li>To check your email, you can use http://gmail.sv.cmu.edu/</li></ul></br>
<li>As a start page, you can use http://my.sv.cmu.edu</li>
Note: We have two domains associated with our campus. "west.cmu.edu" is deprecated and "sv.cmu.edu" is prefered - Due to a Google Apps limitation, you will log in with a west.cmu.edu and urls will contain west.cmu.edu, even though we refer to ourselves as sv.cmu.edu -- you will need to update your account settings so that your email will appear as #{person.email}.
<ul><li>Log into <a href="http://mail.google.com/a/west.cmu.edu/?ui=2#settings/accounts">Account Settings</a></li>
<li>Click "Add another email address you own"</li>
<li>Type in #{person.email}</li>
<li>Click "Send Verification"</li>
<li>Verify the address by going to "Inbox" on the left nav, reading the new email, and clicking on the confirmation link.</li>
<li>Go back to <a href="http://mail.google.com/a/west.cmu.edu/?ui=2#settings/accounts">Account Settings</a></li>
<li>Click "make default" to the right of #{person.email}</li></ul>
<br/>
<b>Andrew email</b><br/>
Your Andrew email account receives all main campus-based communications - including course registration, communications from HUB/Enrollment Services, graduation information, etc.  All Carnegie Mellon community members are assigned an Andrew email account.  As important communications from the main campus are sent to this account, it is also important to review emails received from this account.  We encourage everyone to forward their Andrew email account to their Silicon Valley email account by doing the following:
<ul><li>Go to https://my.cmu.edu/portal/site/main/email/</li>
<li>On the right hand side of the screen, you'll see a section called "Email Forward"</li>
<li>Click on Modify, at the form line "Forward email to:" enter your sv.cmu.edu email address, click Add, and Submit</li>
<li>Mail forwarding will take effect immediately</li>
<li>Email forwarding insures notifications from the university are received and Spam is properly blocked.</li></ul>
__ Action required: I have forwarded my Andrew email to my Silicon Valley email account<br/>
<br/>
<b>TWiki is our primary collaboration tool</b><br/>
We use TWiki, a wiki server, for our collaboration needs.  Faculty use the twiki to collaborate and share important information. Each course will have a twiki web and each student team is given a wiki web for sharing information among the team members.  You will receive a separate email with your twiki account information asking you to set your password.  All wiki words look SomethingLikeThis and we'll cover more about our TWiki server during your orientation.<br/>
<br/>
Your twiki name is "#{person.twiki_name}", and your twiki page url would be:<br/> http://info.sv.cmu.edu/do/view/Main/#{person.twiki_name} -- Please visit your own twiki page and update your biography and objectives.  In the middle of your page, click on 'Edit my information.' This is your opportunity to share information about yourself with your peers.  You can update all of your personal information as well. Your information is only viewable by Silicon Valley community members.<br/>
<br/> __ Action required: I have updated my biography and goals on my twiki user page<br/>
<br/>
<b>Google Apps</b><br/>
Google Apps is composed of a number of tools, including Docs, Calendar, Chat, Sites.<br>
<ul><li><a href="http://gmail.sv.cmu.edu">Email</a> is your primary communication tool between faculty, staff and students.</li>
<li><a href="http://docs.sv.cmu.edu">Docs</a> is used to occasionally share documents for immediate collaboration within small groups. (For long term and larger groups it's more appropriate to use TWiki)</li>
<li><a href="http://calendar.sv.cmu.edu">Calendar</a> is a must. It's used extensively for class/meeting planning, room reservations and various event planning. See <a href="http://info.sv.cmu.edu/do/view/Public/GoogleCalendars">Google Calendars</a> for directions on how to add in the Academic calednar.</li>
<li><u>Chat</u> is just another useful tool for immediate quick communication with other staff and classmates. You can also make voice and video calls with it.</li>
<li><u>Sites</u> can be used to quickly create a website for a small group of collaborators.</li></ul>
<br/>
<b>Adobe Acrobat Connect</b><br/>
Adobe Acrobat Connect is an online meeting, collaboration and presentation tool. We use this tool in our classes to share slides and video feeds with our remote students. Distributed teams use this tool for team meetings (This tool is similar to WebEx and Livemeeting). You will receive an email when your account has been created.The url for adobe connect is http://cmusv.acrobat.com<br/>
<br/>
<b>Yammer</b><br/>
Yammer.com is a twitter like tool. Your messages are broadcasted to your peers, not the world. Please register with your #{person.email} address.<br/>
 <br/>__ Action required: I have registered with yammer<br/>
<br/>
<b>MSDNAA</b>
The MSDN Academic Alliance (MSDNAA) is a library of free Microsoft software for Windows platform. (Office not included). You will receive an email when your account has been created. The url for MSDNAA is http://msdnaa.sv.cmu.edu<br/>
<br/>
<b>Email distribution lists</b><br/>
A sample list of email distribution lists include:<br/>
<ul>
<li>facilities@sv.cmu.edu (room reservations and building inquiries)</li>
<li>help@sv.cmu.edu (tech help)</li>
<li>twiki@sv.cmu.edu (help for TWiki items)</li>
<li>phd-students@sv.cmu.edu</li></ul>
All distribution lists are managed by Tech Ops. For a complete list of distrubtion lists, see http://rails.sv.cmu.edu/mailing_lists. Requests or questions regarding distribution lists should be forwarded to help@sv.cmu.edu<br/>
<br/>
<b>Infrastructure requirements</b>
<br/>
We want every meeting participant to have the best possible experience. If you plan on attending a meeting or a class session remotely you need to have the proper tools. The number one complaint with remote attendees is fellow remote attendees calling in from noisy locations, talking on speaker phones, and not muting their phones. To ensure a clear connection and an effective meeting:<br/>
<ul>
<li>Learn how to use your headset.</li>
<li>Learn how to mute your line.</li>
<li>Use a landline whenever possible.  Avoid using Skype.</li>
<li>Do not use your laptop's internal microphone.</li>
<li>Do not use a speaker phone. </li>
<li>If your peers tell you that they can't hear you, it is your responsibility to do whatever it takes to remedy the situation which may include buying a different headset.  If you don't have a desk headset, we like the Plantronics S12. Cell phone headsets vary so much that we can't recommend one at this time.</li>
</ul>
Review the best practices document:<br/>
http://info.sv.cmu.edu/do/view/Public/ConferenceCallBestPractices<br/>
<br/>
__ Action required: I have the proper headset for my desk phone<br/>
<br/>
__ Action required: I have the proper headset for my cell phone<br/>
<br/>
__ Action required: My phone plan will allow me to participate remotely without resorting to Skype<br/>
<br/>
<b>(Just for students)</b>
Before you arrive, use the Graffiti web for collaboration. We have a twiki web that is designed for student use. We call it Graffiti. You can use that web however you want - from looking for housing in the Silicon Valley, putting on a student social event (e.g. paintball excusion, billards), etc.  For example, if you are looking for housing in the Silicon Valley area and want to talk about what you are finding with other people, create a twiki word in the Graffiti web, email out the word to yammer or a distribution list, and everyone just updates that twiki word. This is a twiki best practice, that way, there is one place to look for current status. http://info.sv.cmu.edu/do/view/Graffiti/WebHome<br/>
<br/>
<b>Questions?</b><br/>
If you have any questions regarding your email account or technical resources at Carnegie Mellon Silicon Valley, please email help@sv.cmu.edu.  If you are a student and have any questions regarding Orientation or other transition items, please contact Gerry Elizondo at gerry.elizondo@sv.cmu.edu.  We look forward to your arrival!

MESSAGE
    
   return message
  end

end
