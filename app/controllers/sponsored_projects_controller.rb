class SponsoredProjectsController < ApplicationController

  before_filter :authenticate_user!

  layout 'cmu_sv'

  def index
    authorize! :read, SponsoredProject
    @projects = SponsoredProject.current
    @sponsors = SponsoredProjectSponsor.current
  end

  def new
    authorize! :create, SponsoredProject
    store_previous_location
    @project = SponsoredProject.new
    @sponsors = SponsoredProjectSponsor.current
  end

  def edit
    authorize! :update, SponsoredProject
    @project = SponsoredProject.find(params[:id])
    @sponsors = SponsoredProjectSponsor.current
  end

  def create
    authorize! :create, SponsoredProject
    @project = SponsoredProject.new(params[:sponsored_project])
    @sponsors = SponsoredProjectSponsor.current

    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_back_or_default(sponsored_projects_path)
    else
      render "new"
    end
  end

  def update
    authorize! :update, SponsoredProject
    @project = SponsoredProject.find(params[:id])
    @sponsors = SponsoredProjectSponsor.current

    if @project.update_attributes(params[:sponsored_project])
      flash[:notice] = 'Project was successfully updated.'
      redirect_to(sponsored_projects_path)
    else
      render "edit"
    end
  end

  def archive
    authorize! :archive, SponsoredProject
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
