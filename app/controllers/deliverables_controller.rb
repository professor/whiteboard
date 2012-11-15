class DeliverablesController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!

  # GET /deliverables
  # GET /deliverables.xml
  def index
    redirect_to my_deliverables_path(current_user)
  end

  def index_for_course
    @course = Course.find(params[:course_id])
    if (current_user.is_admin? || @course.faculty.include?(current_user))
      @deliverables = @course.deliverables
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  def my_deliverables
    @user = User.find(params[:id])

    if (current_user.id != @user.id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
        flash[:error] = I18n.t(:not_your_deliverable)
        redirect_to root_path
        return
      end
    end

    @current_deliverables = Deliverable.find_current_by_user(@user)
    @past_deliverables = Deliverable.find_past_by_user(@user)
    @grouped_deliverables = Deliverable.group_by_semester_course(@current_deliverables + @past_deliverables, @user)

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @deliverables }
    end
  end

  def professor_deliverables
    respond_to do |format|
      format.html {
        @person = User.find(params[:id])
        @semester_years = AcademicCalendar.school_year_semesters
        person_id = @person.id.to_i
        if (current_user.id != person_id)
          unless (current_user.is_staff?)||(current_user.is_admin?)
            flash[:error] = 'You don''t have permission to see gradebooks.'
            redirect_to(people_url) and return
          end
        end
        @courses_teaching_as_faculty = @person.teaching_these_courses
        @deliverable_users = {}
        @courses_teaching_as_faculty.each do |course|
          course.assignments.each do |assignment|
            assignment.deliverables.each do |deliverable|
              @deliverable_users[deliverable.creator.id] = deliverable.creator
            end
          end
        end
        @deliverables = Deliverable.filter(
            semester_year: @semester_years[0],
            course_id: @courses_teaching_as_faculty.map {|course| course.id},
            assignment_id: '',
            submitted_by: '',
            status: 'Ungraded')
      }
      format.js {
        if params[:filter][:course_id].blank?
          params[:filter][:course_id] = current_user.teaching_these_courses.map {|course| course.id}
          store_location
        else
          session[:return_to] = professor_deliverables_path(current_user, course_id: params[:filter][:course_id])
        end
        @deliverables = Deliverable.filter(params[:filter])
      }
    end
  end

  # GET /deliverables/1
  # GET /deliverables/1.xml
  def show
    @deliverable = Deliverable.find(params[:id])

    unless @deliverable.editable?(current_user)
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @deliverable }
    end
  end

  # GET /deliverables/new
  # GET /deliverables/new.xml
  def new
    # If we aren't on this deliverable's team, you can't see it.
    @deliverable = Deliverable.new(:creator => current_user)

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @deliverable }
    end
  end

  # GET /deliverables/1/edit
  def edit
    @deliverable = Deliverable.find(params[:id])

    unless @deliverable.editable?(current_user)
      flash[:error] = I18n.t(:not_your_deliverable)
      redirect_to root_path and return
    end
  end

  # POST /deliverables
  # POST /deliverables.xml
  def create
    if params[:course_id].blank? || params[:deliverable][:assignment_id].blank?
      flash[:error] = 'Must specify both a course and assignment'
      return redirect_to new_deliverable_path
    end

    # Make sure that a file was specified
    @deliverable = Deliverable.new(params[:deliverable])
    @deliverable.creator = current_user

    if @deliverable.assignment.team_deliverable
      @deliverable.update_team
    else
      @deliverable.team = nil
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

    if Assignment.find(params[:deliverable][:assignment_id]).team_deliverable?
      @deliverable.update_team
    else
      @deliverable.team = nil
    end

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
    # Only staff can provide feedback
    if !current_user.is_staff?
      flash[:error] = "Only faculty can provide feedback on deliverables."
      redirect_to :controller => "welcome", :action => "index"
      return
    end

    @deliverable = Deliverable.find(params[:id])
    if !@deliverable.assignment.can_submit
      @deliverable.create_unsubmittable_assignment_deliverable_grades
    end
  end

  def assignment_deliverable_create
    assignment = Assignment.find(params[:assignment_id])
    user = User.find(params[:user_id])

    deliverable = assignment.deliverable(user)
    if deliverable.blank?
      deliverable = assignment.deliverables.build(creator: user, status: "Ungraded")
      if assignment.team_deliverable
        deliverable.creator = user
        team = Team.find_current_by_person_and_course(user, assignment.course)
        deliverable.team = team
      end
      assignment.save
    end

    redirect_to deliverable_feedback_path(deliverable)
  end

  def update_feedback
    if !params[:commit].blank?
      if params[:commit] == "Save as draft"
        params[:deliverable][:status] = 'Draft'
      elsif params[:commit] == "Submit"
        params[:deliverable][:status] = 'Graded'
      end
    end

    @deliverable = Deliverable.find(params[:id])
    @deliverable.attributes = params[:deliverable]

    if @deliverable.has_feedback?
      @deliverable.feedback_updated_at = Time.now
    end

    respond_to do |format|
      if @deliverable.save
        @deliverable.send_deliverable_feedback_email(url_for(@deliverable))
        flash[:notice] = 'Feedback successfully saved.'
        format.html { redirect_back_or_default(professor_deliverables_path(current_user.id)) }
        format.xml { render :xml => @deliverable, :status => :updated, :location => @deliverable }
      else
        flash[:error] = 'Unable to save feedback'
        format.html { render 'edit_feedback' }
        format.xml { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end
end