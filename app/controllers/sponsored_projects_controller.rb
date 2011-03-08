class SponsoredProjectsController < ApplicationController

  layout 'cmu_sv'

  def index
    @projects = SponsoredProject.current
    @sponsors = SponsoredProjectSponsor.current
  end

  def new
    @project = SponsoredProject.new
    @sponsors = SponsoredProjectSponsor.current
  end

  def edit
    @project = SponsoredProject.find(params[:id])
    @sponsors = SponsoredProjectSponsor.current
  end

  def create
    @project = SponsoredProject.new(params[:sponsored_project])
    @sponsors = SponsoredProjectSponsor.current

    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to(sponsored_projects_path)
    else
      render "new"
    end
  end

  def update
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
