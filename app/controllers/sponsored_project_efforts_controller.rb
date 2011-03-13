class SponsoredProjectEffortsController < ApplicationController

  before_filter :require_user

  def index
    month = params[:month] ||= Date.today.month
    year = params[:year] ||= Date.today.year
    @efforts = SponsoredProjectEffort.for_all_users_for_a_given_month(month, year)
  end

  def edit
      @person = Person.find_by_twiki_name(params[:id])

      if @person.id == @current_user.id || @current_user.is_admin
        @efforts = SponsoredProjectEffort.current_months_efforts_for_user(@person.id)
      else
        #bounce with error
      end
  end
end

