class SponsoredProjectsController < ApplicationController

  layout 'cmu_sv'

  def index
    @projects = SponsoredProject.find(:all)
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

  def new_sponsor
    @sponsor = SponsoredProjectSponsor.new
  end

  def edit_sponsor
    @sponsor = SponsoredProjectSponsor.find(params[:id])
  end

end
