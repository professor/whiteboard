class JobsController < ApplicationController
  layout "cmu_sv"

  # GET /jobs
  def index
    @jobs = Job.all
  end

  # GET /jobs/new
  def new
    @job = Job.new
    # @job.supervisors << current_user
    @job.supervisors << User.first
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  def create
    params[:job][:supervisors_override] = params[:supervisors]
    params[:job][:employees_override] = params[:students]
    @job = Job.new(params[:job])

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

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to(@job, :notice => 'Job was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @job.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.xml
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to(jobs_url) }
      format.xml  { head :ok }
    end
  end
end
