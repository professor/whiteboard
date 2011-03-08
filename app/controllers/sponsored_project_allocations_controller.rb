class SponsoredProjectAllocationsController < ApplicationController

  layout 'cmu_sv'

  def index
    @allocations = SponsoredProjectAllocation.current
  end

  def new
    @allocation = SponsoredProjectAllocation.new
    @people = Person.staff
    @projects = SponsoredProject.current
  end

  def edit
    @allocation = SponsoredProjectAllocation.find(params[:id])
    @people = Person.staff
    @projects = SponsoredProject.current
  end

  def create
    @allocation = SponsoredProjectAllocation.new(params[:sponsored_project_allocation])
    @people = Person.staff
    @projects = SponsoredProject.current

    if @allocation.save
      redirect_to(sponsored_project_allocations_path, :notice => 'Allocation was successfully created.')
    else
      render "new"
    end

  end

  def update
    @allocation = SponsoredProjectAllocation.find(params[:id])
    @people = Person.staff
    @projects = SponsoredProject.current

    if @allocation.update_attributes(params[:sponsored_project_allocation])
      redirect_to(sponsored_project_allocations_path, :notice => 'Allocation was successfully updated.')
    else
      render "edit"
    end

  end

  
end
