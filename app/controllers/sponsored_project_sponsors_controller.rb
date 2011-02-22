class SponsoredProjectSponsorsController < ApplicationController

  layout 'cmu_sv'

  def new
    @sponsor = SponsoredProjectSponsor.new
  end

  def edit
    @sponsor = SponsoredProjectSponsor.find(params[:id])
  end

end
