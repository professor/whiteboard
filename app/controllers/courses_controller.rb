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
    (@semester, @year) = AcademicCalendar.valid_semester_and_year(params[:semester])

    if @semester.blank? || @year.blank?
      current_semester = "#{AcademicCalendar.current_semester()}#{Date.today.year}"
      flash[:notice] = "The requested url #{request.path} does not look like /courses/semester/#{current_semester} -- Thus we brought you to the current semester."
      redirect_to("/courses/semester/#{current_semester}")
      return false
    end

    @courses = Course.for_semester(@semester, @year)
    @semester_length_courses = @courses.select { |course| course.mini == "Both" }
    @mini_a_courses = @courses.select { |course| course.mini == "A" }
    @mini_b_courses = @courses.select { |course| course.mini == "B" }

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
      team.members.each do |user|
        @emails << user.email
      end
    end

    @students = Hash.new
    @course.registered_students.each do |student|
      @students[student.human_name] = {:hub => true}
    end
    @course.teams.each do |team|
      team.members.each do |user|
        @students[user.human_name] = (@students[user.human_name] || Hash.new).merge({:team => true, :team_name => team.name})
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @course }
    end
  end

  def gradebook
    store_location
    @course = Course.find(params[:id])
    respond_to do |format|
      format.html { render layout: 'simple' } # gradebook.html.erb
    end
  end

  def export_gradebook
    @course = Course.find(params[:id])

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    sheet.name = 'Grades'
    row = sheet.row(0)
    row2 = sheet.row(1)

    row.push "ID", "Team", "Student"
    row2.push "", "", ""

    sheet.column(0).hidden = true # do not show the ID column to the user

    @course.assignments.each do |assignment|
      row.push assignment.formatted_title, ""
      row2.push "Attachment" ,"Grade"
    end

    row_num = 2

    @course.teams.each do |team|
      team.members.each do |member|
        row = sheet.row(row_num)
        row.push member.id, team.name, member.human_name

        @course.assignments.each do |assignment|
          deliverable_grade = assignment.find_deliverable_grade(member)
          if deliverable_grade.blank?
            row.push "0", "N/A"
          else
            attachment = deliverable_grade.deliverable.current_attachment
            row.push deliverable_grade.grade, attachment.blank? ? "N/A" : Spreadsheet::Link.new(attachment.attachment.url, attachment.attachment_file_name)
          end
        end

        row_num += 1
      end
    end

    filename = Rails.root.join('tmp', 'gradebook_' + @course.name.to_s.gsub(/\s+/, "") + '_' + current_user.human_name.to_s.gsub(/\s+/, "") + '.xls').to_s

    book.write filename
    send_file filename

    File.delete(filename)
  end

  def import_gradebook
    @course = Course.find(params[:id])

    if !@course.faculty.include?(current_user)
      flash[:error] = "Only faculty teaching this course can provide feedback on deliverables."
      redirect_to course_gradebook_path(@course)
      return
    end

    book = Spreadsheet.open(params[:import_spreadsheet][:import_spreadsheet].path)
    sheet = book.worksheet(0)
    assignments = @course.assignments

    # check for validity of deliverable grades
    sheet.each 2 do |row|
      assignment_index = 0
      row.each_with_index do |cell, index|
        if (index > 2) && index.odd?  # only the grade cell are considered
          deliverable_grade = DeliverableGrade.new(deliverable_id: Deliverable.first.id, user_id: current_user.id, grade: cell)
          if !deliverable_grade.valid?
            flash[:error] = "There was a problem parsing your excel file."
            return redirect_to course_gradebook_path(@course)
          end
        end
      end
    end

    sheet.each 2 do |row|
      student = User.find(row[0])
      assignment_index = 0
      row.each_with_index do |cell, index|
        if (index > 2) && index.odd?  # only the grade cell are considered
          assignment = assignments[assignment_index]
          deliverable = assignment.find_or_create_deliverable_by_user(student)
          deliverable_grade = deliverable.deliverable_grades.find_by_user_id(student.id)
          if deliverable_grade.blank?
            deliverable_grade = deliverable.deliverable_grades.create(grade: cell, user: student)
          else
            deliverable_grade.update_attributes(grade: cell)
          end
          deliverable.update_attributes(status: "Graded")
          assignment_index += 1
        end
      end
    end
    flash[:notice] = "Successfully imported excel file to gradebook"
    redirect_to course_gradebook_path(@course)
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
    @assignment = @course.assignments.build
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
    @course.grading_nomenclature = "Tasks"
    @course.grading_criteria = "Points"

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

    update_core
  end

  def update_grading_criteria
    @course = Course.find(params[:id])
    authorize! :update, @course

    update_core
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
        current_team = @course.teams.collect { |team| team if team.members.include?(user) }.compact
        part_time = user.is_part_time ? "PT" : "FT"
        title << [user.human_name, user.formatted_teams(current_team), user.formatted_teams(user.past_teams), part_time, user.local_near_remote, user.masters_program + " " + user.masters_track, user.work_state, user.organization_name]
      end
    end
    send_data(report, :type => 'text/csv;charset=iso-8859-1;', :filename => "past_teams_for_#{@course.display_course_name}.csv",
              :disposition => 'attachment', :encoding => 'utf8')
  end

  def save_task
    @course.assignments.save
  end

  private

  def index_core
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @courses }
    end
  end

  def update_core
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
end
