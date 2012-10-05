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
      @deliverables = Deliverable.find_all_by_course_id(@course.id)
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

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @deliverables }
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

    unless params[:course_id].nil?
      @deliverable.course_id = params[:course_id]
    end
    unless params[:task_number].nil?
      @deliverable.task_number = params[:task_number]
    end

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
    # Make sure that a file was specified
    @deliverable = Deliverable.new(params[:deliverable])
    @deliverable.creator = current_user

    params[:is_team_deliverable] ? @deliverable.update_team : @deliverable.team = nil

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

    params[:is_team_deliverable] ? @deliverable.update_team : @deliverable.team = nil

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
  end

  def update_feedback
    @deliverable = Deliverable.find(params[:id])
    @deliverable.feedback_comment = params[:deliverable][:feedback_comment]
    unless params[:deliverable][:feedback].blank?
      @deliverable.feedback = params[:deliverable][:feedback]
    end
    if @deliverable.has_feedback?
      @deliverable.feedback_updated_at = Time.now
    end
    respond_to do |format|
      if @deliverable.save
        @deliverable.send_deliverable_feedback_email(url_for(@deliverable))
        flash[:notice] = 'Feedback successfully saved.'
        format.html { redirect_to(@deliverable) }
        format.xml { render :xml => @deliverable, :status => :updated, :location => @deliverable }
      else
        flash[:error] = 'Unable to save feedback'
        format.html { redirect_to(@deliverable) }
        format.xml { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end


end
