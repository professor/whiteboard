class SponsoredProjectsController < ApplicationController

  layout 'cmu_sv'

  def index
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")
    @sponsors = SponsoredProjectSponsor.find(:all)
  end

  def new
    @project = SponsoredProject.new
    @sponsors = SponsoredProjectSponsor.find(:all)
  end

  def edit
    @project = SponsoredProject.find(params[:id])
    @sponsors = SponsoredProjectSponsor.find(:all)
  end

  def create
    @project = SponsoredProject.new(params[:sponsored_project])
    @sponsors = SponsoredProjectSponsor.find(:all)

    if @project.save
      redirect_to(sponsored_projects_path, :notice => 'Project was successfully created.')
    else
      render "new"
    end
  end

  def update
    @project = SponsoredProject.find(params[:id])
    @sponsors = SponsoredProjectSponsor.find(:all)

    if @project.update_attributes(params[:sponsored_project])
      redirect_to(sponsored_projects_path, :notice => 'Project was successfully updated.')
    else
      render "edit"
    end
  end


end
