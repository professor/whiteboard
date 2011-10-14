class DelayedSystemJobsController < ApplicationController

  before_filter :authenticate_user!

  layout 'cmu_sv'


  def index
    if has_permissions_or_redirect(:admin, root_path)

      @delayed_system_jobs = DelayedSystemJob.all

      respond_to do |format|
        format.html { render :html => @delayed_system_jobs, :layout => "cmu_sv" } # index.html.erb
        format.js { render :js => @delayed_system_jobs, :layout => false }
        format.xml { render :xml => @delayed_system_jobs }
      end
    end
  end

  # DELETE /delayed_systems_job/1
  # DELETE /delayed_systems_job/1.xml
  def destroy
    if has_permissions_or_redirect(:admin, root_path)

      delayed_system_job = DelayedSystemJob.find(params[:id])
      delayed_system_job.destroy

      respond_to do |format|
        format.html { redirect_to("/delayed_system_jobs") }
        format.xml { head :ok }
      end
    end
  end
end
