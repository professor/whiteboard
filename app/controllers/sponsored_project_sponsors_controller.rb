class SponsoredProjectSponsorsController < ApplicationController

  layout 'cmu_sv'

  before_filter :require_user

  def new
    if has_permissions_or_redirect
      store_previous_location
      @sponsor = SponsoredProjectSponsor.new
    end
  end

  def edit
    if has_permissions_or_redirect
      @sponsor = SponsoredProjectSponsor.find(params[:id])
    end
  end

  def create
    if has_permissions_or_redirect
      @sponsor = SponsoredProjectSponsor.new(params[:sponsored_project_sponsor])

      if @sponsor.save
        flash[:notice] = 'Sponsor was successfully created.'
        redirect_back_or_default(sponsored_projects_path)
      else
        render "new"
      end
    end
  end

  def update
    if has_permissions_or_redirect
      @sponsor = SponsoredProjectSponsor.find(params[:id])

      if @sponsor.update_attributes(params[:sponsored_project_sponsor])
        flash[:notice] = 'Sponsor was successfully updated.'
        redirect_to(sponsored_projects_path)
      else
        render "edit"
      end
    end
  end
  
  def archive
    if has_permissions_or_redirect
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

  protected
  def has_permissions_or_redirect
      unless current_user.permission_level_of(:admin)
        flash[:error] = t(:no_permission)
        redirect_to(Rails.root)
        return false
      end
    return true
  end
end
