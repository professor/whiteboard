class JobsController < ApplicationController
  layout "cmu_sv"

  before_filter :authenticate_user!

  # GET /jobs
  def index
    @jobs = Job.scoped
    @jobs = @jobs.active if params[:show_all] != "true"
  end

  # GET /jobs/new
  def new
    authorize! :create, Job
    @job = Job.new
    @job.supervisors << current_user
    @projects = SponsoredProject.current
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
    authorize! :update, @job
    @projects = SponsoredProject.current
  end

  # POST /jobs
  def create
    authorize! :create, Job
    params[:job][:supervisors_override] = params[:supervisors]
    params[:job][:employees_override] = params[:students]
    @job = Job.new(params[:job])
    @projects = SponsoredProject.current

    respond_to do |format|
      if @job.save
        format.html { redirect_to(jobs_path, :notice => 'Job was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.xml
  def update
    params[:job][:supervisors_override] = params[:supervisors]
    params[:job][:employees_override] = params[:students]
    @job = Job.find(params[:id])
    authorize! :update, @job
    if  params[:job][:is_closed].present? && params[:job][:is_closed] == "true"
      notice_msg = "Job was closed."
    end
    @projects = SponsoredProject.current

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(jobs_path, :notice => notice_msg || 'Job was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def assignments
    authorize! :see_job_details, Job
    @jobs = Job.active
    @all_employees = Job.all_employees
  end

end
