class SponsoredProjectEffortsController < ApplicationController

  before_filter :authenticate_user!

  layout "cmu_sv"

  def index
    if has_permissions_or_redirect(:admin, root_path)
      @month = params[:date][:month].to_i unless params[:date].nil?
      @month = @month ||= 1.month.ago.month
      @year = params[:year] ||= 1.month.ago.year
      @efforts = SponsoredProjectEffort.for_all_users_for_a_given_month(@month, @year)
    end
  end

  def show
    redirect_to(edit_sponsored_project_effort_path)
  end

  def edit
    if authorized_or_redirect
      setup_edit
    end
  end

  def update
    if authorized_or_redirect
      effort_id_values = params[:effort_id_values]

      @failed = false
      @changed_allocation = false
      effort_id_values.each do |key, value|
        effort = SponsoredProjectEffort.find(key)
        #      @changed_allocation = true if effort.actual_allocation != value
        effort.actual_allocation = value
        @changed_allocation = true if effort.actual_allocation_changed?
        effort.confirmed = true
        unless effort.save
          @failed = true
        end
      end
      if @changed_allocation
        SponsoredProjectEffort.emails_business_manager(effort_id_values.keys[0])
      end

      if @failed
        flash.now[:error] = 'Your allocations did not save.'
      else
        flash.now[:notice] = 'Your allocations are confirmed.'
      end

      setup_edit
      render 'edit'
    end
  end

  private
  #Todo: refactor this method to use Application Controller's has_permissions_or_redirect
  def authorized_or_redirect
    @person = Person.find_by_twiki_name(params[:id])
    if (@person.nil?)
      flash[:error] = t(:no_person)
      redirect_to(root_path)
      return false
    end

    unless @person.id == current_user.id || current_user.is_admin
      flash[:error] = t(:no_permission)
      redirect_to(root_path)
      return false
    end
    return true
  end

  def setup_edit
    @efforts = SponsoredProjectEffort.month_under_inspection_for_a_given_user(@person.id)
    @month = !@efforts.empty? ? @efforts[0].month : 1.month.ago.month
    @year = !@efforts.empty? ? @efforts[0].year : 1.month.ago.year
  end

end

