class ProjectTypesController < ApplicationController
  layout 'cmu_sv'
  before_filter :authenticate_user!


  # GET /project_types
  # GET /project_types.xml
  def index
    @project_types = ProjectType.find(:all, :order => "name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @project_types }
    end
  end

  # GET /project_types/1
  # GET /project_types/1.xml
  def show
    @project_type = ProjectType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project_type }
    end
  end

  # GET /project_types/new
  # GET /project_types/new.xml
  def new
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(project_types_url) and return
    end

    @project_type = ProjectType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @project_type }
    end
  end

  # GET /project_types/1/edit
  def edit
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(project_type_url) and return
    end
    @project_type = ProjectType.find(params[:id])
  end

  # POST /project_types
  # POST /project_types.xml
  def create
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(project_types_url) and return
    end

    @project_type = ProjectType.new(params[:project_type])

    respond_to do |format|
      if @project_type.save
        flash[:notice] = 'ProjectType was successfully created.'
        format.html { redirect_to(@project_type) }
        format.xml { render :xml => @project_type, :status => :created, :location => @project_type }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @project_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /project_types/1
  # PUT /project_types/1.xml
  def update
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(project_type_url) and return
    end

    @project_type = ProjectType.find(params[:id])

    respond_to do |format|
      if @project_type.update_attributes(params[:project_type])
        flash[:notice] = 'ProjectType was successfully updated.'
        format.html { redirect_to(@project_type) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /project_types/1
  # DELETE /project_types/1.xml
  def destroy
    if !current_user.is_admin?
      flash[:error] = 'You don' 't have permission to do this action.'
      redirect_to(project_types_url) and return
    end

    @project_type = ProjectType.find(params[:id])
    @project_type.destroy

    respond_to do |format|
      format.html { redirect_to(project_types_url) }
      format.xml { head :ok }
    end
  end
end
