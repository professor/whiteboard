class SponsoredProjectAllocationsController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!

  def index
    authorize! :read, SponsoredProjectAllocation
    @allocations = SponsoredProjectAllocation.current
  end

  def new
    authorize! :create, SponsoredProjectAllocation
    @allocation = SponsoredProjectAllocation.new
    @users = User.staff
    @projects = SponsoredProject.current
  end

  def edit
    authorize! :update, SponsoredProjectAllocation
    @allocation = SponsoredProjectAllocation.find(params[:id])
    @users = User.staff
    @projects = SponsoredProject.current
  end

  def create
    authorize! :create, SponsoredProjectAllocation
    @allocation = SponsoredProjectAllocation.new(params[:sponsored_project_allocation])
    @users = User.staff
    @projects = SponsoredProject.current

    if @allocation.save
      flash[:notice] = 'Allocation was successfully created.'
      redirect_to(sponsored_project_allocations_path)
    else
      render "new"
    end
  end

  def update
    authorize! :update, SponsoredProjectAllocation
    @allocation = SponsoredProjectAllocation.find(params[:id])
    @users = User.staff
    @projects = SponsoredProject.current

    if @allocation.update_attributes(params[:sponsored_project_allocation])
      flash[:notice] = 'Allocation was successfully updated.'
      redirect_to(sponsored_project_allocations_path)
    else
      render "edit"
    end
  end

  def archive
    authorize! :archive, SponsoredProjectAllocation
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
