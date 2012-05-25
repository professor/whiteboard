class SponsoredProjectSponsorsController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!

  def new
    authorize! :create, SponsoredProjectSponsor
    store_previous_location
    @sponsor = SponsoredProjectSponsor.new
  end

  def edit
    authorize! :update, SponsoredProjectSponsor
    @sponsor = SponsoredProjectSponsor.find(params[:id])
  end

  def create
    authorize! :create, SponsoredProjectSponsor
    @sponsor = SponsoredProjectSponsor.new(params[:sponsored_project_sponsor])

    if @sponsor.save
      flash[:notice] = 'Sponsor was successfully created.'
      redirect_back_or_default(sponsored_projects_path)
    else
      render "new"
    end
  end

  def update
    authorize! :update, SponsoredProjectSponsor
    @sponsor = SponsoredProjectSponsor.find(params[:id])

    if @sponsor.update_attributes(params[:sponsored_project_sponsor])
      flash[:notice] = 'Sponsor was successfully updated.'
      redirect_to(sponsored_projects_path)
    else
      render "edit"
    end
  end

  def archive
    authorize! :archive, SponsoredProjectSponsor
    @sponsor = SponsoredProjectSponsor.find(params[:id])
    if @sponsor.update_attributes({:is_archived => true})
      flash[:notice] = 'Sponsor was successfully archived.'
      redirect_to(sponsored_projects_path)
    else
      flash[:notice] = 'Sponsor could not be archived.'
      redirect_to(sponsored_projects_path)
    end
  end

end
