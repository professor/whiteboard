  class DelayedSystemJobsController < ApplicationController

  before_filter :require_user

  layout 'cmu_sv'


  def index
    if !current_user.is_admin?
      flash[:error] = 'You don''t have permission to do this action.'
      redirect_to(root_url) and return
    end

    @delayed_system_jobs = DelayedSystemJob.find(:all)

    respond_to do |format|
      format.html { render :html => @delayed_system_jobs, :layout => "cmu_sv" } # index.html.erb
      format.js   { render :js => @delayed_system_jobs, :layout => false }
      format.xml  { render :xml => @delayed_system_jobs }
    end
  end

  # DELETE /delayed_systems_job/1
  # DELETE /delayed_systems_job/1.xml
  def destroy
    @delayed_system_jobs = DelayedSystemJob.find(params[:id])
    @delayed_system_jobs.destroy

    respond_to do |format|
      format.html { redirect_to("/delayed_system_jobs") }
      format.xml  { head :ok }
    end
  end

end
