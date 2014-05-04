class DeliverablesController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!
  before_filter :render_grade_book_menu, :only => [:grading_queue_for_course, :show]

  def render_grade_book_menu
    @is_in_grade_book = true if (current_user.is_staff?)||(current_user.is_admin?)
  end

  # GET /deliverables
  # GET /deliverables.xml
  def index
    redirect_to my_deliverables_path(current_user)
  end

  def grading_queue_for_course

    @course = Course.find(params[:course_id])

    if @course.grading_rule.nil?
      flash[:error] = I18n.t(:no_grading_rule_for_course)
      redirect_to course_path(@course) and return
    end
    if @course.grading_rule.default_values?
      flash.now[:error] = I18n.t(:default_grading_rule_for_course)
    end

    # Retrieving assignments names for the course to be able to filter by deliverable name later on.
    @assignments = Assignment.where(:course_id => @course.id).all
    # Team Turing: this fails when the task is nil.
    # @assignments = Assignment.where(:course_id => @course.id).all.sort_by(&:task_number)


    if @course.faculty_and_teaching_assistants.include?(current_user)
      # Get all deliverables for this team/student
      @deliverables = Deliverable.get_deliverables(params[:course_id], current_user.id, {:is_my_team => 1})

      @deliverables = @deliverables.select { |deliverable| deliverable.grade_status == "ungraded" ||
          deliverable.grade_status == "drafted" }

      @deliverables = @deliverables.sort { |a, b| b.assignment.assignment_order <=> a.assignment.assignment_order }
    else
      has_permissions_or_redirect(:admin, root_path)
    end

  end

  def get_deliverables
    filter_options = params[:filter_options] || Hash.new
    @deliverables = filter_deliverables(params[:course_id], filter_options)
    respond_to do |format|
      format.js
    end
  end

  #temporary for mel
  def team_index_for_course
    @course = Course.find(params[:course_id])
    if (current_user.is_admin? || @course.faculty_and_teaching_assistants.include?(current_user))
      @deliverables = Deliverable.where("team_id is not null").find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  #temporary for mel
  def individual_index_for_course
    @course = Course.find(params[:course_id])
    if (current_user.is_admin? || @course.faculty_and_teaching_assistants.include?(current_user))
      @deliverables = Deliverable.where("team_id is null").find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  def my_deliverables
    user = User.find_by_param(params[:id])
    if (current_user.id != user.id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
        flash[:error] = I18n.t(:not_your_deliverable)
        redirect_to root_path
        return
      end
    end
    @current_deliverables = Deliverable.find_current_by_user(user)
    @past_deliverables = Deliverable.find_past_by_user(user)
    @current_assignments = Assignment.list_assignments_for_student(user.id, :current)
    @current_courses = user.registered_for_these_courses_during_current_semester()
    @past_assignments = Assignment.list_assignments_for_student(user.id, :past)
    @past_courses = user.registered_for_these_courses_during_past_semesters()
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @deliverables }
    end
  end

  # GET /deliverables/1
  # GET /deliverables/1.xml
  def show
    @deliverable = Deliverable.find(params[:id])
    @course = @deliverable.course
    @hostname_with_port = request.host_with_port
    unless @deliverable.editable?(current_user)
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end

    if (current_user.is_admin? || @course.faculty_and_teaching_assistants.include?(current_user))
      if @course.grading_rule.nil?
        flash[:error] = I18n.t(:no_grading_rule_for_course)
        redirect_to course_path(@course) and return
      end
      if @course.grading_rule.default_values?
        flash.now[:error] = I18n.t(:default_grading_rule_for_course)
      end
    end

    respond_to do |format|
      if (current_user.is_admin? || @course.faculty_and_teaching_assistants.include?(current_user))
        format.html { render layout: false }
      else
        format.html # show.html.erb
        format.xml { render :xml => @deliverable }
      end

    end
  end

  # GET /deliverables/new
  # GET /deliverables/new.xml
  def new
    # If we aren't on this deliverable's team, you can't see it.
    @deliverable = Deliverable.new(:creator => current_user)
    @courses = current_user.registered_for_these_courses_during_current_semester

    if params[:course_id]
      @deliverable.course_id = params[:course_id]
      @assignments = Course.find(params[:course_id]).assignments.where(:is_submittable => true)
    else
      if @courses.empty?
        @assignments = []
      else
        @assignments = @courses[0].assignments.where(:is_submittable => true)
      end
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @deliverable }
    end
  end

  # GET /deliverables/1/edit
  def edit
    @deliverable = Deliverable.find(params[:id])

    @courses = current_user.registered_for_these_courses_during_current_semester
    @assignments = @deliverable.course.assignments.where(:is_submittable => true)

    unless @deliverable.editable?(current_user)
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end
  end

  # POST /deliverables
  # POST /deliverables.xml
  def create
    # Make sure that a file was specified
    @deliverable = Deliverable.new(params[:deliverable])
    @deliverable.creator = current_user
    @deliverable.is_team_deliverable ? @deliverable.update_team : @deliverable.team = nil

    if @deliverable.is_team_deliverable && @deliverable.team == nil
      flash[:error] = "You are not on a team in this course, so you can't submit a team deliverable"
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
      return
    end

    if !params[:deliverable_attachment][:attachment]
      flash[:error] = 'Must specify a file to upload'
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
      return
    end
    @attachment = DeliverableAttachment.new(params[:deliverable_attachment])
    @attachment.submitter = @deliverable.creator
    @deliverable.attachment_versions << @attachment
    @attachment.deliverable = @deliverable

    respond_to do |format|
      if @attachment.valid? and @deliverable.valid? and @deliverable.save
        @deliverable.send_deliverable_upload_email(url_for(@deliverable))
        flash[:notice] = 'Deliverable was successfully created.'
        format.html { redirect_to(@deliverable) }
        format.xml { render :xml => @deliverable, :status => :created, :location => @deliverable }
      else
        if not @attachment.valid?
          flash[:notice] = 'Attachment not valid'
        elsif not @deliverable.valid?
          flash[:notice] = 'Deliverable not valid'
        else
          flash[:notice] = 'Something else went wrong'
        end
        format.html { render :action => "new" }
        format.xml { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deliverables/1
  # PUT /deliverables/1.xml
  def update
    @deliverable = Deliverable.find(params[:id])

#    params[:is_team_deliverable] ? @deliverable.update_team : @deliverable.team = nil
    @deliverable.is_team_deliverable ? @deliverable.update_team : @deliverable.team = nil

    unless @deliverable.editable?(current_user)
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end

    there_is_an_attachment = params[:deliverable_attachment][:attachment]
    if there_is_an_attachment

      @attachment = DeliverableAttachment.new(params[:deliverable_attachment])
      @attachment.submitter = current_user
      @deliverable.attachment_versions << @attachment
      @attachment.deliverable = @deliverable

      if @attachment.valid? and @deliverable.valid? and @deliverable.update_attributes(params[:deliverable])
        @deliverable.send_deliverable_upload_email(url_for(@deliverable))
        flash[:notice] = 'Deliverable was successfully updated.'
        redirect_to(@deliverable)
      else
        render :action => "edit"
      end
    else
      if @deliverable.valid? and @deliverable.update_attributes(params[:deliverable])
        flash[:notice] = 'Deliverable was successfully updated.'
        redirect_to(@deliverable)
      else
        render :action => "edit"
      end
    end


  end

  # DELETE /deliverables/1
  # DELETE /deliverables/1.xml
  def destroy
    @deliverable = Deliverable.find(params[:id])

    unless @deliverable.editable?(current_user)
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end
    @deliverable.destroy

    respond_to do |format|
      format.html { redirect_to(deliverables_url) }
      format.xml { head :ok }
    end
  end

  def edit_feedback
    if @course.grading_rule.nil?
      flash[:error] = I18n.t(:no_grading_rule_for_course)
      redirect_to course_path(@course) and return
    end

    @deliverable = Deliverable.find(params[:id])

#    if !@deliverable.assignment.course.faculty_and_teaching_assistants.include?(current_user)
#      flash[:error] = "Only faculty teaching this course can provide feedback on deliverables. #{current_user.human_name}"
#      redirect_to :controller => "welcome", :action => "index"
#      return
#    end
  end


  def update_feedback
    @deliverable = Deliverable.find(params[:id])

    unless (current_user.is_admin? || @deliverable.course.faculty_and_teaching_assistants.include?(current_user))
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end

    # check is save and email is clicked or save as draft is clicked
    is_student_visible=true
    if params[:submit]
      is_student_visible=true
      @deliverable.update_attributes(:grade_status => "graded")
    elsif params[:draft]
      is_student_visible=false
      @deliverable.update_attributes(:grade_status => "drafted")
    end


    flash[:error] = @deliverable.update_grade(params, is_student_visible, current_user.id)
    other_email = nil
    if params[:send_copy_to_myself] == "1"
      other_email = current_user.email
    end
    if @deliverable.update_feedback_and_notes(params[:deliverable])
      if is_student_visible == true
        @deliverable.send_deliverable_feedback_email(url_for(@deliverable), other_email)
      end
    else
      flash[:error] << 'Unable to save feedback'
    end

    #Obtain current selected filters to update the queue accordingly
    if params[:deliverable][:current_filter_options].present?
      @selected_filter_options = JSON.parse(params[:deliverable][:current_filter_options])
    else
      @selected_filter_options = Hash.new
    end
    @deliverables = filter_deliverables(@deliverable.course_id, @selected_filter_options)

    respond_to do |format|
      if flash[:error].blank?
        flash[:error] = nil
        flash[:notice] = 'Feedback successfully saved.'
        format.js
      else
        flash[:error] = flash[:error].join("<br>")
        format.html { redirect_to(@deliverable) }
      end
    end
  end

  #Todo: rename this method
  #get_assginemments_for_course
  #shouldn't this be in the assignments controller?
  def get_assignments_for_student
    unless params[:course_id].nil?
      @assignments = Course.find(params[:course_id]).assignments.all(:conditions => ["is_submittable = ?", true])
      @assignments_array = @assignments.collect { |assignment| {:assignment => assignment.attributes.merge({:name_with_type => assignment.name_with_type})} }
      respond_to do |format|
        format.json { render json: @assignments_array }
      end
    end
  end

  private
  def filter_deliverables (course_id, filter_options)
    @course = Course.find_by_id(course_id)

    # Prepare filter options according to what users select on the page
    options = {}
    if filter_options[:search_box] != ""
      options[:search_string] = filter_options[:search_box]
    end

    if filter_options['is_my_teams'] == 'yes'
      options[:is_my_team] = 1
    else
      options[:is_my_team] = 0
    end


    # Filter in the model by course, professor, my teams and search input
    @deliverables = []
    @faculty_deliverables = Deliverable.get_deliverables(course_id, current_user.id, options)

    # Filter once again according to the selected grading options. If no filter options are selected,
    # display every deliverable
    @selected_options = []
    filter_options.collect do |filter_option|
      @selected_options << filter_option[0].to_sym if filter_option[1] == "1"
    end
    if @selected_options.size == 0
      @deliverables = @faculty_deliverables
    else
      @selected_options.each do |option|
#        @deliverables.concat(@faculty_deliverables.select { |deliverable| deliverable.get_grade_status == option })
        @deliverables.concat(@faculty_deliverables.select { |deliverable| deliverable.grade_status == option.to_s })
      end
    end

    # Filter by assignment names in drop down menu
    unless filter_options["assignment_id"] == '-1'
      @deliverables = @deliverables.select { |deliverable| deliverable.assignment_id == filter_options[
          "assignment_id"].to_i }
    end

    @deliverables = @deliverables.sort { |a, b| b.assignment.assignment_order <=> a.assignment.assignment_order }
  end

end

