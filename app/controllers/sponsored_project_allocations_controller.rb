class SponsoredProjectAllocationsController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!

  def index
    if has_permissions_or_redirect(:admin, root_path)
      @allocations = SponsoredProjectAllocation.current
    end
  end

  def new
    if has_permissions_or_redirect(:admin, root_path)
      @allocation = SponsoredProjectAllocation.new
      @people = Person.staff
      @projects = SponsoredProject.current
    end
  end

  def edit
    if has_permissions_or_redirect(:admin, root_path)
      @allocation = SponsoredProjectAllocation.find(params[:id])
      @people = Person.staff
      @projects = SponsoredProject.current
    end
  end

  def create
    if has_permissions_or_redirect(:admin, root_path)
      @allocation = SponsoredProjectAllocation.new(params[:sponsored_project_allocation])
      @people = Person.staff
      @projects = SponsoredProject.current

      if @allocation.save
        flash[:notice] = 'Allocation was successfully created.'
        redirect_to(sponsored_project_allocations_path)
      else
        render "new"
      end
    end
  end

  def update
    if has_permissions_or_redirect(:admin, root_path)
      @allocation = SponsoredProjectAllocation.find(params[:id])
      @people = Person.staff
      @projects = SponsoredProject.current

      if @allocation.update_attributes(params[:sponsored_project_allocation])
        flash[:notice] = 'Allocation was successfully updated.'
        redirect_to(sponsored_project_allocations_path)
      else
        render "edit"
      end
    end
  end

  def archive
    if has_permissions_or_redirect(:admin, root_path)
      @allocation = SponsoredProjectAllocation.find(params[:id])
      if @allocation.update_attributes({:is_archived => true})
        flash[:notice] = 'Allocation was successfully archived.'
        redirect_to(sponsored_project_allocations_path)
      else
        flash[:notice] = 'Allocation could not be archived.'
        redirect_to(sponsored_project_allocations_path)
      end
    end
  end

end
