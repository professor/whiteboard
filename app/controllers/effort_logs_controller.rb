class EffortLogsController < ApplicationController
#  layout "cmu_sv_no_pad", :except => :new_effort_log_line_item

#  layout 'cmu_sv_no_pad', :only => [:index, :show]
  layout 'simple'

  before_filter :authenticate_user!, :except => [:create_midweek_warning_email, :create_endweek_admin_email]


  # Todo: consider moving these email methods to the model(EffortLogs) and update the rake task accordingly
  #
  def create_midweek_warning_email
    if (!EffortLog.log_effort_week?(Date.today.cwyear, Date.today.cweek))
      #We skip weeks that students aren't taking courses
      logger.info "There is no class this week, so we won't remind students to log effort"
      return
    end

    random_scotty_saying = ScottyDogSaying.all.sample.saying

    courses = Course.remind_about_effort_course_list
    courses.each do |course_id|
      create_midweek_warning_email_for_course(random_scotty_saying, course_id)
    end

  end

  def create_midweek_warning_email_for_course(random_scotty_saying, course_id)
    year = Date.today.cwyear
    week_number = Date.today.cweek

    course = Course.find(course_id)
    users = course.registered_students | course.teams.collect { |team| team.members }.flatten
    users.each do |user|
      logger.debug "**    user #{user.human_name}"
      effort_log = EffortLog.where(:user_id => user.id, :week_number => week_number, :year => year).first
      if (!user.emailed_recently(:effort_log))
        EffortLogMailer.midweek_warning(random_scotty_saying, user).deliver
        user.effort_log_warning_email = Time.now
        user.save
      end
    end
  end

  def create_endweek_faculty_email
    notify_course_list = Course.remind_about_effort_course_list

    #notify_course_list = [48, 47, 46]  #list all courses that we want to track effort
    last_week = (Date.today - 7).cweek
    last_week_year = (Date.today -7).cwyear

    if (!EffortLog.log_effort_week?(last_week_year, last_week))
      logger.info "There was no class last week, so we won't remind students to log effort"
      return
    end

    notify_course_list.each do |course|
      faculty = {}
      teams = Team.where(:course_id => course.id)
      teams.each do |team|
        faculty[team.primary_faculty_id] = 1 unless team.primary_faculty_id.nil?
        faculty[team.secondary_faculty_id] = 1 unless team.secondary_faculty_id.nil?
      end
      faculty_emails = []
      faculty.each { |faculty_id, value| faculty_emails << User.find_by_id(faculty_id).email }
      EffortLogMailer.endweek_admin_report(course.id, course.name, faculty_emails).deliver
    end
  end

  def update_task_type_select
    unless params[:task_id].blank?
      logger.debug "updated " + params[:task_id]
      @selected_type = TaskType.find_by_id(params[:task_id])
    end

    render :partial => "description_update"
  end

  # GET /effort_logs
  # GET /effort_logs.xml
  def index
    @effort_logs = EffortLog.find_effort_logs(current_user)

    if Date.today.cweek == 1 #If the first week of the year, then we set to the last week of previous year
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
      format.xml { render :xml => @effort_logs }
    end
  end

  # GET /effort_logs/1
  # GET /effort_logs/1.xml
  def show
    @effort_log = EffortLog.find(params[:id])
    setup_required_datastructures(@effort_log.year, @effort_log.week_number)

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @effort_log }
    end
  end


  # GET /effort_logs/new
  # GET /effort_logs/new.xml
  def new
    if params[:prior] == 'true' then
      if Date.today.cweek == 1
        week_number = 52
        year = Date.today.cwyear -1
      else
        week_number = Date.today.cweek - 1
        year = Date.today.cwyear
      end
      error_msg = "There already is an effort log for the previous week"
    else
      week_number = Date.today.cweek
      year = Date.today.cwyear
      error_msg = "There already is an effort log for the current week"
    end
    setup_required_datastructures(year, week_number)

    @effort_log = EffortLog.new
    @effort_log.user_id = current_user.id

    #find the most recent effort log to copy its structure, but not its effort data
    recent_effort_log = EffortLog.where(:user_id => current_user.id).order("year DESC, week_number DESC").first

    # We want to make sure that the user isn't accidentally creating two efforts for the same week.
    # Since students are only able to log effort for this week (or a previous week)
    if recent_effort_log and recent_effort_log.week_number == week_number
      #Yes we already have effort for this week
      duplicate_effort_log = recent_effort_log
    else
      #Do we already have effort for the week we are trying to log effort against?
      duplicate_effort_log = EffortLog.where(:user_id => current_user.id, :week_number => week_number, :year => year).first
    end

    if duplicate_effort_log
      logger.debug "We should not be creating another effort log for week #{week_number}"
      flash[:error] = error_msg
      redirect_to(effort_logs_url) and return
    end

    if recent_effort_log
      logger.debug "Copy effort log from week #{recent_effort_log.week_number}"
      recent_effort_log.effort_log_line_items.each do |line|
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


    @effort_log.year = year
    @effort_log.week_number = week_number

#          format.html # new.html.erb
#      format.xml  { render :xml => @effort_log }


    respond_to do |format|
      if @effort_log.save
        flash[:notice] = 'EffortLog was successfully created.'
        format.html { redirect_to(edit_effort_log_url(@effort_log.id)) }
        format.xml { render :xml => @effort_log, :status => :created, :location => @effort_log }
      else
        flash[:notice] = 'Unable to create new EffortLog.'
        format.html { redirect_to(effort_logs_url) }
        format.xml { render :xml => @effort_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /effort_logs/1/edit
  def edit
    @effort_log = EffortLog.find(params[:id])

#    if @effort_log.week_number != Date.today.cweek
    if !@effort_log.editable_by(current_user)
      flash[:error] = 'You do not have permission to edit the effort log.'
      redirect_to(effort_logs_url) and return
    end
#    if !@effort_log.has_permission_to_edit_period(current_user)
#      flash[:error] = 'You are unable to update effort logs from the past.'
#      redirect_to(effort_logs_url) and return
#    end
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
        format.xml { render :xml => @effort_log, :status => :created, :location => @effort_log }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @effort_log.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /effort_logs/1
  # PUT /effort_logs/1.xml
  def update
    params[:effort_log][:existing_effort_log_line_item_attributes] ||= {}

    @effort_log = EffortLog.find(params[:id])
    if !@effort_log.editable_by(current_user)
      flash[:error] = 'You do not have permission to edit the effort log.'
      redirect_to(effort_logs_url) and return
    end
#    if !@effort_log.has_permission_to_edit_period(current_user)
#      flash[:error] = 'You are unable to update effort logs from the past.'
#      redirect_to(effort_logs_url) and return
#    end

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
        format.xml { head :ok }
      else
        format.html { render "edit" }
        format.xml { render :xml => @effort_log.errors, :status => :unprocessable_entity }
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
      format.xml { head :ok }
    end
  end

  def effort_for_unregistered_courses
    @error_effort_logs_users = EffortLog.users_with_effort_against_unregistered_courses()
    respond_to do |format|
      format.html
      format.xml { render :xml => @error_effort_logs_users }
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
    @day_labels = [1, 2, 3, 4, 5, 6, 7].collect do |day|
      Date.commercial(year, week_number, day).strftime "%b %d" # Jul 01
    end

    @courses = Course.where(:year => Date.today.cwyear, :semester => AcademicCalendar.current_semester())

    @task_types = TaskType.where(:is_student => true)

    @today_column = which_column_is_today(year, week_number)
  end

  def which_column_is_today year, week_number
    column = "none"
    [1, 2, 3, 4, 5, 6, 7].collect do |day|
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
    Course.order("id DESC").first
  end


end
