class SponsoredProjectAllocationsController < ApplicationController

  layout 'cmu_sv'

  def index
    @allocations = SponsoredProjectAllocation.find(:all, :order => 'person_id ASC')

  end

  def new
    @allocation = SponsoredProjectAllocation.new
    @people = Person.staff
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")
  end

  def edit
    @allocation = SponsoredProjectAllocation.find(params[:id])
    @people = Person.staff
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")
  end

  def create
    @allocation = SponsoredProjectAllocation.new(params[:sponsored_project_allocation])
    @people = Person.staff
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")

    if @allocation.save
      redirect_to(sponsored_project_allocations_path, :notice => 'Allocation was successfully created.')
    else
      render "new"
    end

  end

  def update
    @allocation = SponsoredProjectAllocation.find(params[:id])
    @people = Person.staff
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")

    if @allocation.update_attributes(params[:sponsored_project_allocation])
      redirect_to(sponsored_project_allocations_path, :notice => 'Allocation was successfully updated.')
    else
      render "edit"
    end

  end

  
end
