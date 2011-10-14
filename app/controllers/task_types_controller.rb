class TaskTypesController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  # GET /task_types
  # GET /task_types.xml
  def index
#    @task_types = TaskType.locate_appropriate_by_user_type
    @task_types = locate_appropriate_by_user_type
    ##
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @task_types }
    end
  end

  # GET /task_types/1
  # GET /task_types/1.xml
  def show
    @task_type = TaskType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @task_type }
    end
  end

  # GET /task_types/new
  # GET /task_types/new.xml
  def new
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(task_types_url) and return
    end

    @task_type = TaskType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @task_type }
    end
  end

  # GET /task_types/1/edit
  def edit
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(task_type_url) and return
    end

    @task_type = TaskType.find(params[:id])
  end

  # POST /task_types
  # POST /task_types.xml
  def create
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(task_types_url) and return
    end

    @task_type = TaskType.new(params[:task_type])

    respond_to do |format|
      if @task_type.save
        flash[:notice] = 'TaskType was successfully created.'
        format.html { redirect_to(@task_type) }
        format.xml { render :xml => @task_type, :status => :created, :location => @task_type }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @task_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /task_types/1
  # PUT /task_types/1.xml
  def update
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(task_type_url) and return
    end

    @task_type = TaskType.find(params[:id])

    respond_to do |format|
      if @task_type.update_attributes(params[:task_type])
        flash[:notice] = 'TaskType was successfully updated.'
        format.html { redirect_to(@task_type) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @task_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /task_types/1
  # DELETE /task_types/1.xml
  def destroy
    if !current_user.is_admin?
      flash[:error] = 'You don' 't have permission to do this action.'
      redirect_to(task_types_url) and return
    end

    @task_type = TaskType.find(params[:id])
    @task_type.destroy

    respond_to do |format|
      format.html { redirect_to(task_types_url) }
      format.xml { head :ok }
    end
  end

  private
  def locate_appropriate_by_user_type
    if current_user.is_student? && current_user.is_staff?
      task_types = TaskType.find(:all)
    end
    if current_user.is_student? && !current_user.is_staff?
      task_types = TaskType.find(:all, :conditions => ['is_student = ?', true])
    end
    if !current_user.is_student? && current_user.is_staff?
      task_types = TaskType.find(:all, :conditions => ['is_staff = ?', true])
    end
    if !current_user.is_student? && !current_user.is_staff?
      task_types = TaskType.all
    end
    return task_types
  end
end
