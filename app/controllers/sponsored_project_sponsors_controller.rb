class SponsoredProjectSponsorsController < ApplicationController

  layout 'cmu_sv'

  def new
    @sponsor = SponsoredProjectSponsor.new
  end

  def edit
    @sponsor = SponsoredProjectSponsor.find(params[:id])
  end

  def create
    @sponsor = SponsoredProjectSponsor.new(params[:sponsored_project_sponsor])

    if @sponsor.save
      redirect_to(sponsored_projects_path, :notice => 'Sponsor was successfully created.')
    else
      render "new"
    end
  end

  def update
    @sponsor = SponsoredProjectSponsor.find(params[:id])

    if @sponsor.update_attributes(params[:sponsored_project_sponsor])
      redirect_to(sponsored_projects_path, :notice => 'Sponsor was successfully updated.')
    else
      render "edit"
    end
  end

end
