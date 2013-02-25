class DeliverablesController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!
  before_filter :render_grade_book_menu, :only=>[:index_for_course, :show]

  def render_grade_book_menu
    @is_in_grade_book = true if (current_user.is_staff?)||(current_user.is_admin?)
  end

  # GET /deliverables
  # GET /deliverables.xml
  def index
    redirect_to my_deliverables_path(current_user)
  end

  def index_for_course
    @course = Course.find(params[:course_id])
    if (current_user.is_admin? || @course.faculty.include?(current_user))
      @deliverables = Deliverable.where(:course_id => @course.id).all
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  #temporary for mel
  def team_index_for_course
    @course = Course.find(params[:course_id])
    if (current_user.is_admin? || @course.faculty.include?(current_user))
      @deliverables = Deliverable.where("team_id is not null").find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  #temporary for mel
  def individual_index_for_course
    @course = Course.find(params[:course_id])
    if (current_user.is_admin? || @course.faculty.include?(current_user))
      @deliverables = Deliverable.where("team_id is null").find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  def student_deliverables_and_grades_for_course
    @course = Course.find(params[:course_id])
    if (params[:user_id])
      @user = User.find_by_param(params[:user_id])
    else
      @user = current_user
    end
    if (current_user.id != @user.id)
      unless (@course.faculty.include?(current_user))||(current_user.is_admin?)
        flash[:error] = I18n.t(:not_your_deliverable)
        redirect_to root_path
        return
      end
    end
    @assignments = @course.assignments
    respond_to do |format|
      format.html { render :action => "student_deliverables" }
      format.xml { render :xml => @assignments }
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
    @current_assignments = Assignment.list_assignments_for_student(user.id , :current)
    @current_courses = user.registered_for_these_courses_during_current_semester()
    @past_assignments = Assignment.list_assignments_for_student(user.id ,:past)
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
    @deliverable = Deliverable.find(params[:id])

#    if !@deliverable.assignment.course.faculty.include?(current_user)
#      flash[:error] = "Only faculty teaching this course can provide feedback on deliverables. #{current_user.human_name}"
#      redirect_to :controller => "welcome", :action => "index"
#      return
#    end
  end



  def update_feedback
    @deliverable = Deliverable.find(params[:id])

    # check is save and email is clicked or save as draft is clicked
    is_student_visible=true
    if params[:submit]
      is_student_visible=true
    elsif params[:draft]
      is_student_visible=false
    end

    flash[:error] = @deliverable.update_grade(params, is_student_visible)
    if @deliverable.update_feedback_and_notes(params[:deliverable])
      if is_student_visible==true
        @deliverable.send_deliverable_feedback_email(url_for(@deliverable))
      end
    else
      flash[:error] << 'Unable to save feedback'
    end

    respond_to do |format|
       if flash[:error].blank?
         flash[:error] = nil
         flash[:notice] = 'Feedback successfully saved.'
         format.html {redirect_to(course_deliverables_path(@deliverable.course))}
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
      @assignments_array =  @assignments.collect{ |assignment| {:assignment => assignment.attributes.merge({:name_with_type => assignment.name_with_type}) }}
      respond_to do |format|
        format.json { render json:  @assignments_array }
      end
    end
  end

end
