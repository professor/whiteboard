class SponsoredProjectsPeopleController < ApplicationController

  layout 'cmu_sv'

  def index
    @allocations = SponsoredProjectsPeople.find(:all)

  end

  def new
    @allocation = SponsoredProjectsPeople.new
    @people = Person.staff
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")
  end

  def edit
    @allocation = SponsoredProjectsPeople.find(params[:id])
    @people = Person.staff
    @projects = SponsoredProject.find(:all, :order => "SPONSOR_ID ASC, NAME ASC")
  end

  
end
