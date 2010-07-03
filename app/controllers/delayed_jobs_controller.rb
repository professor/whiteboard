class DelayedJobsController < ApplicationController

  before_filter :require_user

  layout 'cmu_sv'


  def index
    if !current_user.is_admin?
      flash[:error] = 'You don''t have permission to do this action.'
      redirect_to(root_url) and return
    end

    @delayed_jobs = DelayedJob.find(:all)

    respond_to do |format|
      format.html { render :html => @delayed_jobs, :layout => "cmu_sv" } # index.html.erb
      format.js   { render :js => @delayed_jobs, :layout => false }
      format.xml  { render :xml => @delayed_jobs }
    end
  end



end
