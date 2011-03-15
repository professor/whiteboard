class SponsoredProjectEffortsController < ApplicationController

  before_filter :require_user

  layout "cmu_sv"

  def index
    @month = params[:month] ||= Date.today.month
    @year = params[:year] ||= Date.today.year
    @efforts = SponsoredProjectEffort.for_all_users_for_a_given_month(@month, @year)
  end

  def show
    redirect_to(edit_sponsored_project_effort_path)
  end

  def edit
    setup_edit
  end

  def update
    effort_id_values = params[:effort_id_values]

    effort_id_values.each do |key,value|
      effort = SponsoredProjectEffort.find(key)
      effort.actual_allocation = value
      effort.confirmed = true
      effort.save
    end

    setup_edit
    flash.now[:notice] = 'Your allocations are confirmed.'
    render 'edit'
  end

private
  def setup_edit
      @person = Person.find_by_twiki_name(params[:id])

      if @person.id == @current_user.id || @current_user.is_admin
        @efforts = SponsoredProjectEffort.current_months_efforts_for_user(@person.id)
      else
        #bounce with error
      end
  end

end

