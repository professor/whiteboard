class IndividualContributionsController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!   #, :except => [:create_midweek_warning_email, :create_endweek_admin_email]


  # GET /individual_contributions
  # GET /individual_contributions.xml
  def index
    @individual_contributions = IndividualContribution.find_individual_contributions(current_user)

    @current_week_number = Date.today.cweek
    @year = Date.today.cwyear

    if @current_week_number == 1 #If the first week of the year, then we set to the last week of previous year
      @previous_week_number = 52
      @previous_week_year = @year - 1
    else
      @previous_week_number = @current_week_number - 1
      @previous_week_year = @year
    end

    current_week = IndividualContribution.find_by_week(@year, @current_week_number, current_user)
    previous_week = IndividualContribution.find_by_week(@previous_week_year, @previous_week_number, current_user)


    @show_new_link_for_current_week = !current_week ? true : false
    @show_new_link_for_previous_week = (Date.today.monday? && !previous_week) ? true : false

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @individual_contributions }
    end
  end


  def new

    @questions = ["Helo", "heelo"]


  end

  # Todo: consider moving these email methods to the model(StatusReports) and update the rake task accordingly
  #
#  def create_midweek_warning_email
#    if (!IndividualContribution.log_effort_week?(Date.today.cwyear, Date.today.cweek))
#      #We skip weeks that students aren't taking courses
#      logger.info "There is no class this week, so we won't remind students to log effort"
##      flash[:error] = 'Students are taking courses this week'
##     redirect_to(root_path)
#      return
#    end
#
#    @people_with_effort = Array.new
#    @people_without_effort = Array.new
#    random_scotty_saying = ScottyDogSaying.all.sample.saying
#
#    courses = Course.remind_about_effort_course_list
#    courses.each do |course_id|
#      create_midweek_warning_email_for_course(random_scotty_saying, course_id)
#    end
#
#    (with_effort, without_effort) = create_midweek_warning_email_for_se_students(random_scotty_saying)
#    @people_with_effort = @people_with_effort + with_effort
#    @people_without_effort = @people_without_effort + without_effort
#
#    StatusReportMailer.midweek_warning_admin_report(random_scotty_saying, @people_without_effort, @people_with_effort).deliver
#
#    logger.info "There were #{@people_without_effort.size} without effort."
#    @people_without_effort.each do |person|
#      logger.debug "#{person}"
#    end
#    logger.info "There were #{@people_with_effort.size} with effort."
#    @people_with_effort.each do |person|
#      logger.debug "#{person}"
#    end
#
##   respond_to do |format|
##      format.html # index.html.erb
##    end
##    render(:text => "E-Mail sent")
#
#  end
#
#  def create_midweek_warning_email_for_course(random_scotty_saying, course_id)
#    year = Date.today.cwyear
#    week_number = Date.today.cweek
#    teams = Team.where("course_id = ? ", course_id)
#    teams.each do |team|
#      logger.debug "** team #{team.name}"
#      team.people.each do |person|
#        logger.debug "**    person #{person.human_name}"
#        status_report = IndividualContribution.where("person_id = ? and week_number = ? and year = ?", person.id, week_number, year).first
#        if (!person.emailed_recently(:status_report))
#          if ((status_report.nil? || status_report.sum == 0)&&(!person.emailed_recently(:status_report)))
#            #            logger.debug "**  sent email to #{person.human_name} (#{person.id}) for #{week_number} of #{year} in course #{course_id}"
#            create_midweek_warning_email_send_it(random_scotty_saying, person.id)
#            @people_without_effort << person.human_name
#          else
#            logger.debug "**  no   email to #{person.human_name} (#{person.id}) for #{week_number} of #{year} in course #{course_id}"
#            @people_with_effort << person.human_name
#          end
#          person.status_report_warning_email = Time.now
#          person.save
#        end
#      end
#    end
#  end
#
#  def create_midweek_warning_email_for_se_students(random_scotty_saying)
#    people_without_effort = []
#    people_with_effort = []
#    year = Date.today.cwyear
#    week_number = Date.today.cweek
#    people = Person.where("masters_program = ? and is_active = true and is_alumnus = false", "SE")
#    people.each do |person|
#      status_report = IndividualContribution.latest_for_person(person.id, week_number, year)
#      if (!person.emailed_recently(:status_report))
#        if ((status_report.nil? || status_report.sum == 0)&&(!person.emailed_recently(:status_report)))
#          create_midweek_warning_email_send_it(random_scotty_saying, person.id)
#          people_without_effort << person.human_name
#        else
#          people_with_effort << person.human_name
#        end
#        person.status_report_warning_email = Time.now
#        person.save
#      end
#    end
#    return people_without_effort, people_with_effort
#  end
#
#
#  def create_midweek_warning_email_send_it(random_scotty_saying, id)
#    user = User.find_by_id(id)
#    StatusReportMailer.midweek_warning(random_scotty_saying, user).deliver
#    #render(:text => "<pre>" + email.encoded + "</pre>")
#
#  end
#
#  def create_endweek_faculty_email
#    notify_course_list = Course.remind_about_effort_course_list
#
#    #notify_course_list = [48, 47, 46]  #list all courses that we want to track effort
#    last_week = (Date.today - 7).cweek
#    last_week_year = (Date.today -7).cwyear
#
#    if (!IndividualContribution.log_effort_week?(last_week_year, last_week))
#      logger.info "There was no class last week, so we won't remind students to log effort"
#      return
#    end
#
#    notify_course_list.each do |course|
#      faculty = {}
#      teams = Team.where("course_id = ? ", course.id)
#      teams.each do |team|
#        faculty[team.primary_faculty_id] = 1 unless team.primary_faculty_id.nil?
#        faculty[team.secondary_faculty_id] = 1 unless team.secondary_faculty_id.nil?
#      end
#      faculty_emails = []
#      faculty.each { |faculty_id, value| faculty_emails << User.find_by_id(faculty_id).email }
#      StatusReportMailer.endweek_admin_report(course.id, course.name, faculty_emails).deliver
#    end
#  end
#
#  def update_task_type_select
#    unless params[:task_id].blank?
#      logger.debug "updated " + params[:task_id]
#      @selected_type = TaskType.find_by_id(params[:task_id])
#    end
#
#    render :partial => "description_update"
#  end


  # GET /status_reports/1
  # GET /status_reports/1.xml
  def show
    @status_report = IndividualContribution.find(params[:id])
    setup_required_datastructures(@status_report.year, @status_report.week_number)

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @status_report }
    end
  end


  # GET /status_reports/new
  # GET /status_reports/new.xml
  def new
    if params[:previous] == 'true' then
      if Date.today.cweek == 1
        week_number = 52
        year = Date.today.cwyear -1
      else
        week_number = Date.today.cweek - 1
        year = Date.today.cwyear
      end
      error_msg = "There already is an status report for the previous week"
    else
      week_number = Date.today.cweek
      year = Date.today.cwyear
      error_msg = "There already is an status report for the current week"
    end
    setup_required_datastructures(year, week_number)

    @status_report = IndividualContribution.new
    @status_report.person_id = current_user.id

    #find the most recent status report to copy its structure, but not its effort data
    recent_status_report = IndividualContribution.where("person_id = '#{current_user.id}'", :order => "year DESC, week_number DESC").first

    # We want to make sure that the user isn't accidentally creating two efforts for the same week.
    # Since students are only able to log effort for this week (or a previous week)
    if recent_status_report and recent_status_report.week_number == week_number
      #Yes we already have effort for this week
      duplicate_status_report = recent_status_report
    else
      #Do we already have effort for the week we are trying to log effort against?
      duplicate_status_report = IndividualContribution.where("person_id = '#{current_user.id}' AND year = #{year} AND week_number = #{week_number}").first
    end

    if duplicate_status_report
      logger.debug "We should not be creating another status report for week #{week_number}"
      flash[:error] = error_msg
      redirect_to(status_reports_url) and return
    end

    if recent_status_report
      logger.debug "Copy status report from week #{recent_status_report.week_number}"
      recent_status_report.status_report_line_items.each do |line|
        @status_report.status_report_line_items << StatusReportLineItem.new(:course_id => line.course_id, :task_type_id => line.task_type_id)
      end
    else
      logger.debug "This is the first status report for the person in the system"

      course = recent_foundations_or_course
      course_id = course.id

      @task_types.each do |task_type|
        @status_report.status_report_line_items << StatusReportLineItem.new(:course_id => course_id, :task_type_id => task_type.id)
      end
    end

    # Ps. if we wanted to have an status report with a single status report line item that is blank, then this would do it       @status_report.status_report_line_items.build      


    @status_report.year = year
    @status_report.week_number = week_number

#          format.html # new.html.erb
#      format.xml  { render :xml => @status_report }


    respond_to do |format|
      if @status_report.save
        flash[:notice] = 'IndividualContribution was successfully created.'
        format.html { redirect_to(edit_status_report_url(@status_report.id)) }
        format.xml { render :xml => @status_report, :status => :created, :location => @status_report }
      else
        flash[:notice] = 'Unable to create new IndividualContribution.'
        format.html { redirect_to(status_reports_url) }
        format.xml { render :xml => @status_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /status_reports/1/edit
  def edit
    @status_report = IndividualContribution.find(params[:id])

#    if @status_report.week_number != Date.today.cweek
    if !@status_report.editable_by(current_user)
      flash[:error] = 'You do not have permission to edit the status report.'
      redirect_to(status_reports_url) and return
    end
#    if !@status_report.has_permission_to_edit_period(current_user)
#      flash[:error] = 'You are unable to update status reports from the past.'
#      redirect_to(status_reports_url) and return
#    end
    setup_required_datastructures(@status_report.year, @status_report.week_number)
  end

  # POST /status_reports
  # POST /status_reports.xml
  def create
    @status_report = IndividualContribution.new(params[:status_report])

    setup_required_datastructures(@status_report.year, @status_report.week_number)


    respond_to do |format|
      if @status_report.save
        course_error_msg = @status_report.validate_effort_against_registered_courses()
        flash[:notice] = 'IndividualContribution was successfully created.'
        if (course_error_msg!="")
          flash[:error] = 'You are not on a team in the following course(s) ' + course_error_msg
        end
        format.html { redirect_to(@status_report) }
        format.xml { render :xml => @status_report, :status => :created, :location => @status_report }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @status_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /status_reports/1
  # PUT /status_reports/1.xml
  def update
    params[:status_report][:existing_status_report_line_item_attributes] ||= {}

    @status_report = IndividualContribution.find(params[:id])
    if !@status_report.editable_by(current_user)
      flash[:error] = 'You do not have permission to edit the status report.'
      redirect_to(status_reports_url) and return
    end
#    if !@status_report.has_permission_to_edit_period(current_user)
#      flash[:error] = 'You are unable to update status reports from the past.'
#      redirect_to(status_reports_url) and return
#    end

    setup_required_datastructures(@status_report.year, @status_report.week_number)

    respond_to do |format|
      if @status_report.update_attributes(params[:status_report])
        #check to see if user is logging effort for unregistered courses
        course_error_msg = @status_report.validate_effort_against_registered_courses()
        flash[:notice] = 'IndividualContribution was successfully updated.'
        if (course_error_msg!="")
          flash[:error] = 'You are not on a team in the following course(s)<br/>' + course_error_msg
        end
        format.html { redirect_to(edit_status_report_url) }
        format.xml { head :ok }
      else
        format.html { render "edit" }
        format.xml { render :xml => @status_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /status_reports/1
  # DELETE /status_reports/1.xml
  def destroy
    @status_report = IndividualContribution.find(params[:id])
    @status_report.destroy

    respond_to do |format|
      format.html { redirect_to(status_reports_url) }
      format.xml { head :ok }
    end
  end

  def effort_for_unregistered_courses
    @error_status_reports_users = IndividualContribution.users_with_effort_against_unregistered_courses()
    respond_to do |format|
      format.html
      format.xml { render :xml => @error_status_reports_users }
    end
  end

  #Typically an ajax call
  def new_status_report_line_item
    setup_required_datastructures(Date.today.cwyear, Date.today.cweek)
    @status_report_line_item = StatusReportLineItem.new
    @status_report_line_item.status_report_id = params[:status_report_id]
    @status_report_line_item.save
  end

  private

  def setup_required_datastructures(year, week_number)
    @day_labels = [1, 2, 3, 4, 5, 6, 7].collect do |day|
      Date.commercial(year, week_number, day).strftime "%b %d" # Jul 01
    end

    @courses = Course.where('year = ? and semester = ?', Date.today.cwyear, AcademicCalendar.current_semester())

    @task_types = TaskType.where('is_student = ?', true)

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
