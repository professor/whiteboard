class SponsoredProjectsController < ApplicationController

  before_filter :authenticate_user!

  layout 'cmu_sv'

  def index
    if has_permissions_or_redirect
      @projects = SponsoredProject.current
      @sponsors = SponsoredProjectSponsor.current
    end
  end

  def new
    if has_permissions_or_redirect
      store_previous_location
      @project = SponsoredProject.new
      @sponsors = SponsoredProjectSponsor.current
    end
  end

  def edit
    if has_permissions_or_redirect
      @project = SponsoredProject.find(params[:id])
      @sponsors = SponsoredProjectSponsor.current
    end
  end

  def create
    if has_permissions_or_redirect
      @project = SponsoredProject.new(params[:sponsored_project])
      @sponsors = SponsoredProjectSponsor.current

      if @project.save
        flash[:notice] = 'Project was successfully created.'
        redirect_back_or_default(sponsored_projects_path)
      else
        render "new"
      end
    end
  end

  def update
    if has_permissions_or_redirect
      @project = SponsoredProject.find(params[:id])
      @sponsors = SponsoredProjectSponsor.current

      if @project.update_attributes(params[:sponsored_project])
        flash[:notice] = 'Project was successfully updated.'
        redirect_to(sponsored_projects_path)
      else
        render "edit"
      end
    end
  end

  def archive
    if has_permissions_or_redirect
      @project = SponsoredProject.find(params[:id])
      if @project.update_attributes({:is_archived => true})
        flash[:notice] = 'Project was successfully archived.'
        redirect_to(sponsored_projects_path)
      else
        flash[:notice] = 'Project could not be archived.'
        redirect_to(sponsored_projects_path)
      end
    end
  end

  protected
  def has_permissions_or_redirect
    unless current_user.permission_level_of(:admin)
      flash[:error] = t(:no_permission)
      redirect_to(root_path)
      return false
    end
    return true
  end


end
