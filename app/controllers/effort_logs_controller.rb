class EffortLogsController < ApplicationController
#  layout "cmu_sv", :except => :new_effort_log_line_item

#  layout 'cmu_sv', :only => [:index, :show]


  before_filter :require_user, :except => [:create_midweek_warning_email, :create_endweek_admin_email ]


  # Todo: consider moving these email methods to the model and update the rake task accordingly
  #
  def create_midweek_warning_email
    if (!Course.week_during_semester?(Date.today.cweek))
      #We skip weeks that students aren't taking courses
      puts "There is no class this week, so we won't remind students to log effort"
#      flash[:error] = 'Students are taking courses this week'
 #     redirect_to(root_url)
      return
    end

    @people_with_effort = Array.new
    @people_without_effort = Array.new
    random_scotty_saying = ScottyDogSaying.find(:all).rand.saying

#   courses = [48, 47, 46]  #list all courses that we want to track effort
   courses = Course.remind_about_effort_course_list
   courses.each do |course_id|
       create_midweek_warning_email_for_course(random_scotty_saying, course_id)
    end

    EffortLogMailer.deliver_midweek_warning_admin_report(random_scotty_saying, @people_without_effort, @people_with_effort)

    puts "There were #{@people_without_effort.size} without effort."
    puts ""
    @people_without_effort.each do |person|
      puts "#{person}"
    end
    puts ""
    puts "There were #{@people_with_effort.size} with effort."
    puts ""
    @people_with_effort.each do |person|
      puts "#{person}"
    end


#   respond_to do |format|
#      format.html # index.html.erb
#    end
    #    render(:text => "E-Mail sent")

  end

  def create_midweek_warning_email_for_course(random_scotty_saying, course_id)
    year = Date.today.cwyear
    week_number = Date.today.cweek
    teams = Team.find(:all, :conditions => ["course_id = ? ", course_id])   
    teams.each do |team| 
      logger.debug "** team #{team.name}"
      team.people.each do |person|
        logger.debug "**    person #{person.human_name}"
        effort_log = EffortLog.find(:first, :conditions => ["person_id = ? and week_number = ? and year = ?", person.id, week_number, year])
        if(!person.emailed_recently)
          if((effort_log.nil? || effort_log.sum == 0)&&(!person.emailed_recently))
  #            logger.debug "**  sent email to #{person.human_name} (#{person.id}) for #{week_number} of #{year} in course #{course_id}"
            create_midweek_warning_email_send_it(random_scotty_saying, person.id)
            @people_without_effort << person.human_name
          else
            logger.debug "**  no   email to #{person.human_name} (#{person.id}) for #{week_number} of #{year} in course #{course_id}"
            @people_with_effort << person.human_name
          end
          person.effort_log_warning_email = Time.now
          person.save
        end
      end
    end
  end
 
  def create_midweek_warning_email_send_it(random_scotty_saying, id)
    user = User.find_by_id(id) 
##    email = EffortLogMailer.create_midweek_warning(user) 
##    render(:text => "<pre>" + email.encoded + "</pre>") 
    email = EffortLogMailer.deliver_midweek_warning(random_scotty_saying, user)
  end

  def create_endweek_faculty_email
    notify_course_list = Course.remind_about_effort_course_list()

#    notify_course_list = [48, 47, 46]  #list all courses that we want to track effort
    last_week = (Date.today - 7).cweek

#    if (Date.today.cweek != 1)
#      #normal week
#      last_week = Date.today.cweek - 1 unless false
#    else
#      #first week of the year
#      last_week = (Date.today - 7).cweek 
#    end
    if (!Course.week_during_semester?(last_week))
        puts "There was no class last week, so we won't remind students to log effort"
        return
    end

    notify_course_list.each do |course|
      faculty = {}
      teams = Team.find(:all, :conditions => ["course_id = ? ", course.id])
      teams.each do |team|
        faculty[team.primary_faculty_id] = 1 unless team.primary_faculty_id.nil?
        faculty[team.secondary_faculty_id] = 1 unless team.secondary_faculty_id.nil?
      end
      faculty_emails = []
      faculty.each {|faculty_id, value| faculty_emails << User.find_by_id(faculty_id).email }
      EffortLogMailer.deliver_endweek_admin_report(course.id, course.name, faculty_emails)
    end
  end
    
  def update_task_type_select
    unless params[:task_id].blank?
      logger.debug "updated " + params[:task_id]      
#      @sub_types = SubTaskType.find(:all, :conditions => ['task_type_id = ?', params[:task_id]])
      @selected_type = TaskType.find_by_id(params[:task_id])
    end
    
    render :partial => "description_update"
  end
  
  # GET /effort_logs
  # GET /effort_logs.xml
  def index
    @effort_logs = EffortLog.find(:all, :conditions => "person_id = '#{current_user.id}'", :order => "year DESC, week_number DESC")

    if Date.today.cweek == 1  #If the first week of the year, then we set to the last week of previous year
      @prior_week_number = 52
      @year = Date.today.cwyear - 1
    else
      @prior_week_number = Date.today.cweek - 1
      @year = Date.today.cwyear
    end

    # if no effort logs created
    if @effort_logs.empty?
      # show new current link
      @show_new_link = true

      # if no effort logs created and today is Monday, then show new prior link
      if Date.today.cwday == 1
        @show_prior_week = true
      else
        @show_prior_week = false
      end
    else
      # if most recent effort log is for current period, then don't show new current link, else show new current link
      if @effort_logs[0].year == Date.today.cwyear && @effort_logs[0].week_number == Date.today.cweek
        @show_new_link = false
      else
        @show_new_link = true
      end

      # start by always showing prior week link
      @show_prior_week = true

      #if today is Monday, evaluate, otherwise don't show prior week link
      if Date.today == Date.commercial(Date.today.cwyear, Date.today.cweek, 1)
        # if most recent log is a match, then don't show prior week link
        if (@effort_logs[0].year == @year && @effort_logs[0].week_number == @prior_week_number)
          @show_prior_week = false
        end
        # if second most recent entry is a match, then don't show prior week link
        if @effort_logs[1]
          if (@effort_logs[1].year == @year && @effort_logs[1].week_number == @prior_week_number)
            @show_prior_week = false
          end
        end
      else
        # if not Monday, don't ever show the prior week link
        @show_prior_week = false
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @effort_logs }
    end
  end



  
  
  # GET /effort_logs/1
  # GET /effort_logs/1.xml
  def show
    @effort_log = EffortLog.find(params[:id])
    setup_required_datastructures(@effort_log.year, @effort_log.week_number)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @effort_log }
    end
  end

  
  # GET /effort_logs/new
  # GET /effort_logs/new.xml
  def new
    if params[:prior] == 'true' then
      week_number = Date.today.cweek - 1
      week_number = 52 if Date.today.cweek == 1
      error_msg = "There already is an effort log for the previous week"
    else
      week_number = Date.today.cweek - 0
      error_msg = "There already is an effort log for the current week"
    end
    setup_required_datastructures(Date.today.cwyear, week_number)

    @effort_log = EffortLog.new
    @effort_log.person_id = current_user.id
    
    #find the most recent effort log to copy its structure, but not its effort data
    recent_effort_log = EffortLog.find(:first, :conditions => "person_id = '#{current_user.id}'", :order => "year DESC, week_number DESC")

    if recent_effort_log
      logger.debug "Copy effort log from week #{recent_effort_log.week_number}"
      if recent_effort_log.week_number == week_number
        logger.debug "We should not be creating another effort log for week #{week_number}"
        flash[:error] = error_msg
        redirect_to(effort_logs_url) and return        
      end
      recent_effort_log.effort_log_line_items.each do | line|
        @effort_log.effort_log_line_items << EffortLogLineItem.new(:course_id => line.course_id, :task_type_id => line.task_type_id)
      end
    else
      logger.debug "This is the first effort log for the person in the system"

      course = recent_foundations_or_course
      course_id = course.id

      @task_types.each do |task_type|
        @effort_log.effort_log_line_items << EffortLogLineItem.new(:course_id => course_id, :task_type_id => task_type.id)      
      end
    end
        
    # Ps. if we wanted to have an effort log with a single effort log line item that is blank, then this would do it       @effort_log.effort_log_line_items.build      

            
    @effort_log.year = Date.today.cwyear
    @effort_log.week_number = week_number
    
#          format.html # new.html.erb
#      format.xml  { render :xml => @effort_log }

    
    respond_to do |format|
      if @effort_log.save
        flash[:notice] = 'EffortLog was successfully created.'
        format.html { redirect_to(edit_effort_log_url(@effort_log.id)) }
        format.xml  { render :xml => @effort_log, :status => :created, :location => @effort_log }
      else
        flash[:notice] = 'Unable to create new EffortLog.'
        format.html { redirect_to(effort_logs_url) }
        format.xml  { render :xml => @effort_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /effort_logs/1/edit
  def edit
    @effort_log = EffortLog.find(params[:id])

#    if @effort_log.week_number != Date.today.cweek
    if !@effort_log.editable(current_user)          
      flash[:error] = 'You are unable to update effort logs from the past.'
      redirect_to(effort_logs_url) and return
    end
    setup_required_datastructures(@effort_log.year, @effort_log.week_number)
  end

  # POST /effort_logs
  # POST /effort_logs.xml
  def create
    @effort_log = EffortLog.new(params[:effort_log])

    setup_required_datastructures(@effort_log.year, @effort_log.week_number)

        
    respond_to do |format|
      if @effort_log.save
        course_error_msg = @effort_log.validate_effort_against_registered_courses()
        flash[:notice] = 'EffortLog was successfully created.'
        if (course_error_msg!="")
           flash[:error] = 'You are not on a team in the following course(s) ' + course_error_msg
        end
        format.html { redirect_to(@effort_log) }
        format.xml  { render :xml => @effort_log, :status => :created, :location => @effort_log }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @effort_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /effort_logs/1
  # PUT /effort_logs/1.xml
  def update
    params[:effort_log][:existing_effort_log_line_item_attributes] ||= {}
    
    @effort_log = EffortLog.find(params[:id])
    if !@effort_log.editable(current_user)        
      flash[:error] = 'You are unable to update effort logs from the past.'
      redirect_to(effort_logs_url) and return
    end
        
    setup_required_datastructures(@effort_log.year, @effort_log.week_number)
        
    respond_to do |format|
      if @effort_log.update_attributes(params[:effort_log])
        #check to see if user is logging effort for unregistered courses
        course_error_msg = @effort_log.validate_effort_against_registered_courses()
        flash[:notice] = 'EffortLog was successfully updated.'
        if (course_error_msg!="")
           flash[:error] = 'You are not on a team in the following course(s)<br/>' + course_error_msg
        end
        format.html { redirect_to(edit_effort_log_url) }
        format.xml  { head :ok }
      else
        format.html { redirect_to(edit_effort_log_url) }        
        format.xml  { render :xml => @effort_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /effort_logs/1
  # DELETE /effort_logs/1.xml
  def destroy
    @effort_log = EffortLog.find(params[:id])
    @effort_log.destroy

    respond_to do |format|
      format.html { redirect_to(effort_logs_url) }
      format.xml  { head :ok }
    end
  end

  def effort_for_unregistered_courses
    @error_effort_logs_users = EffortLog.users_with_effort_against_unregistered_courses()
    tmp = EffortLog.users_with_effort_against_unregistered_courses()
    puts "Hello"
    respond_to do |format|
      format.html
      format.xml  { render :xml => @error_effort_logs_users }
    end
  end

  #Typically an ajax call
  def new_effort_log_line_item
    setup_required_datastructures(Date.today.cwyear, Date.today.cweek)
    @effort_log_line_item = EffortLogLineItem.new
    @effort_log_line_item.effort_log_id = params[:effort_log_id]
    @effort_log_line_item.save        
  end

private
  
  def setup_required_datastructures(year, week_number)
    @day_labels = [1,2,3,4,5,6,7].collect do |day|
      Date.commercial(year, week_number, day).strftime "%b %d"  # Jul 01
    end

    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.cwyear, ApplicationController.current_semester()] )
    @projects = Project.find(:all, :conditions => "is_closed = FALSE", :order => "name ASC")
    
    if current_user.is_staff? && current_user.is_student?
      @task_types = TaskType.find(:all )           
    elsif current_user.is_staff? && !current_user.is_student?
      @task_types = TaskType.find(:all, :conditions => ['is_staff = ?', true] )
    else
      @task_types = TaskType.find(:all, :conditions => ['is_student = ?', true] )
    end
    @today_column = which_column_is_today(year, week_number)
  end
  
  def which_column_is_today year, week_number
    column = "none"
    [1,2,3,4,5,6,7].collect do |day| 
      column = day if Date.commercial(year, week_number, day) == Date.today
    end
    return column
  end
  
  def recent_foundations_or_course
#    name = "Foundations"
#    recent_foundations = Course.find :first, :conditions =>  ["name like ?", "%" + name + "%"], :order => "year DESC"
#    if !recent_foundations.nil? 
#      return recent_foundations
#    end
    Course.find(:first, :order => "id DESC")
  end
  

end
