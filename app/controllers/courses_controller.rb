class CoursesController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  # GET /courses
  # GET /courses.xml
  def index
    @all_courses = true
    @courses = Course.order("year DESC, semester DESC, number ASC").all
    @courses = @courses.sort_by { |c| -c.sortable_value } # note the '-' is for desc sorting

    index_core
  end

  def current_semester
    @all_courses = false
    @semester = AcademicCalendar.current_semester()
    @year = Date.today.year
    @courses = Course.for_semester(@semester, @year)
    index_core
  end

  def next_semester
    @all_courses = false
    @semester = AcademicCalendar.next_semester()
    @year = AcademicCalendar.next_semester_year()
    @courses = Course.for_semester(@semester, @year)
    index_core
  end

  # GET /courses/1
  # GET /courses/1.xml
  def show
    @course = Course.find(params[:id])

    teams = Team.where("course_id = ?", params[:id])

    @emails = []
    teams.each do |team|
      team.people.each do |person|
        @emails << person.email
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.xml
  def new
    if has_permissions_or_redirect(:staff, root_path)
      @course = Course.new
      @course.semester = AcademicCalendar.next_semester
      @course.year = AcademicCalendar.next_semester_year

      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @course }
      end
    end
  end

  # GET /courses/1/edit
  def edit
    if has_permissions_or_redirect(:staff, root_path)
      @course = Course.find(params[:id])
    end
  end

  def configure
    if has_permissions_or_redirect(:staff, root_path)
      edit
    end
  end

  # POST /courses
  # POST /courses.xml
  def create
    if has_permissions_or_redirect(:staff, root_path)
      @last_offering = Course.last_offering(params[:course][:number])
      if @last_offering.nil?
        @course = Course.new(:name => "New Course", :mini => "Both", :number => params[:course][:number])
      else
        @course = @last_offering.copy_as_new_course
      end

      @course.year = params[:course][:year]
      @course.semester = params[:course][:semester]

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
  end

  # PUT /courses/1
  # PUT /courses/1.xml
  def update
    if has_permissions_or_redirect(:staff, root_path)
      @course = Course.find(params[:id])

      if (params[:course][:is_configured]) #The previous page was configure action
        @course.twiki_url = params[:course][:curriculum_url] if params[:course][:configure_course_twiki]
        @course.configured_by_user_id = current_user.id
      else
        msg = @course.update_faculty(params[:people])
        unless msg.blank?
          flash.now[:error] = msg
          render :action => 'edit'
          return
        end
      end

      respond_to do |format|
        @course.updated_by_user_id = current_user.id if current_user
        if @course.update_attributes(params[:course])
          if (params[:course][:is_configured]) #The previous page was configure action
            CourseMailer.configure_course_admin_email(@course).deliver
                                               #            CourseMailer.configure_course_admin_email.deliver(@course)
          else #email faculty to configure the course, unless it was already configured

          end
          flash[:notice] = 'Course was successfully updated.'
          format.html { redirect_to(@course) }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @course.errors, :status => :unprocessable_entity }
        end
      end
    end
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
    file_content = params[:file].read().gsub("\n", ' ')
    parsed_courses = file_content.split('CLASS ROSTER')

    unless parsed_courses.any?
      flash[:error] = "Could not read your file"
      index_core and return
    end

    students_for_course = {}
    old_students_for_course = {}

    parsed_courses.each do |parsed_course|
      if /Run Date: (.*) Course: (.*) Sect:\s*(\w+).*Semester: (.*)College:(.*)Department:(.*)Instructor\(s\): (.*)Name.*?_+(.*)/.match(parsed_course)
        #run_date = $1.strip
        course_id = $2.strip
        #sect = $3.strip
        #semester = $4.strip
        #college = $5.strip
        #department = $6.strip
        #instructors = $7.strip
        student_ids = $8.scan(/\d+\.\d.*?(\w+)/)

        # find course in the database
        Course.all.each do |course|
          # if we find course, we need to replace '-'
          Rails.logger.debug("Student IDS:::: #{student_ids.inspect}")
          if course.number.gsub('-', '').to_s.eql?(course_id)
            first_occurrence_of_course = old_students_for_course[course.id].nil?
            old_students_for_course[course.id] = course.users.collect { |user| user.id }.to_set unless old_students_for_course[course.id]

            if first_occurrence_of_course
              course.users = []
              Rails.logger.debug "Clearing course #{course.id}"
              course.save
            end

            student_ids.each do |student_id|
              # if we find students by their andrew email account
              #arr =  arr+ #{student_id[0]}
              student = User.find_by_webiso_account("#{student_id[0]}@andrew.cmu.edu")
              if not student.nil?
                students_for_course[course.id] = Set.new unless students_for_course[course.id]
                students_for_course[course.id] << student.id
                Rails.logger.debug("Added student #{student_id[0]} for course #{course.id}")
              end
            end
            ## create array of newly added userids and dropped userids
            #new_userids=[]
            #dropped_userids=[]
            #old_userlist.all.each do |old_userid|
            #  if(course.users.find_by_webiso_account(old_userid.).nil?)
            #    dropped_userids<<
            #  end
            #end
          end
        end
      end
    end

    Rails.logger.debug "Students for course::: #{students_for_course.inspect}"
    students_for_course.each do |course_id, student_ids|
      crs = Course.find(course_id)
      student_ids.each do |stud_id|
        crs.users << User.find(stud_id)
      end
      crs.save
    end

    unless students_for_course.any?
      flash[:error] = "Could not read your file"
      index_core and return
    end
    # make arrays for new user_ids and dropped user_ids
    to_notify = {}
    old_students_for_course.each do |old_course_id, old_student_ids|
      new_student_ids = students_for_course[old_course_id]
      added = (new_student_ids || Set.new) - (old_student_ids || Set.new)
      Rails.logger.debug("Added for #{old_course_id}:::: #{added.inspect}")
      dropped = (old_student_ids || Set.new) - (new_student_ids || Set.new)
      Rails.logger.debug("Dropped for #{old_course_id}:::: #{dropped.inspect}")
      to_notify[old_course_id] = {:added => added, :dropped => dropped}
    end

    to_notify.each do |course_id, info|
      next if info[:added].blank? && info[:dropped].blank?

      course = Course.find(course_id)

      message = ""
      if info[:added].present?
        message += "New Students added to the course:\n"
        i=1
        info[:added].each do |student_id|
          student = User.find(student_id)
          message += i.to_s+". #{student.first_name}  #{student.last_name}\n"
          i = i+1
        end
      end

      if info[:dropped].present?
        i=1
        message += "Students dropped from the course:\n"
        info[:dropped].each do |student_id|
          student = User.find(student_id)
          message += i.to_s+". #{student.first_name}  #{student.last_name}\n"
          i = i+1
        end
      end

      options = {:to => course.faculty.collect(&:email), :subject => "Roster change for your course #{course.name}",
                 :message => message}
      GenericMailer.email(options).deliver
    end
    #course.faculty.
    #
    #    end


    index_core

  end


  private
  def index_core
    @all_courses = true unless @all_courses
    @courses = Course.order("year DESC, semester DESC, number ASC").all unless @courses
    @courses = @courses.sort_by { |c| -c.sortable_value } # note the '-' is for desc sorting

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @courses }
    end
  end
end
