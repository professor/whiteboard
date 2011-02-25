class SponsoredProjectAllocationsController < ApplicationController

  layout 'cmu_sv'

  def index
    @allocations = SponsoredProjectAllocation.find(:all)

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

  
end
