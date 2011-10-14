class ProjectsController < ApplicationController
  layout 'cmu_sv'
  before_filter :authenticate_user!

  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.find(:all, :conditions => "is_closed = FALSE", :order => "name ASC")

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(projects_url) and return
    end

    @project = Project.new
    @project_types = ProjectType.find(:all, :order => "name ASC")
    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.year, AcademicCalendar.current_semester()])

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(project_url) and return
    end

    @project = Project.find(params[:id])
    @project_types = ProjectType.find(:all, :order => "name ASC")
    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.year, AcademicCalendar.current_semester()])
  end

  # POST /projects
  # POST /projects.xml
  def create
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(projects_url) and return
    end

    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml { render :xml => @project, :status => :created, :location => @project }
      else
        flash[:notice] = 'Oops'
        format.html { render :action => "new" }
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(project_url) and return
    end

    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    if !current_user.is_admin?
      flash[:error] = 'You don' 't have permission to do this action.'
      redirect_to(project_types_url) and return
    end

    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml { head :ok }
    end
  end

#  def close
#    @project = Project.find(params[:id])
#    @project.is_closed = true
#    
#    respond_to do |format|
#      if @project.save
#        flash[:notice] = 'Project was successfully updated.'
#        format.html { redirect_to(@project) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
#      end
#    end
#  end  

end
