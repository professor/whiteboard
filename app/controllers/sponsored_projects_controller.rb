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

end
