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
      redirect_to(sponsored_projects_path, :notice => 'Project was successfully created.')
    else
      render "new"
    end
  end

  def update
    @project = SponsoredProject.find(params[:id])
    @sponsors = SponsoredProjectSponsor.current

    if @project.update_attributes(params[:sponsored_project])
      redirect_to(sponsored_projects_path, :notice => 'Project was successfully updated.')
    else
      render "edit"
    end
  end


end
