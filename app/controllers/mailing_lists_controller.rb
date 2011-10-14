class MailingListsController < ApplicationController
  before_filter :authenticate_user!

  layout 'cmu_sv'


  # GET /mailing_lists
  # GET /mailing_lists.xml
  def index
    @mailing_lists = []
    google_apps_connection.retrieve_all_groups.each do |list|
      # group_name = list.group_id.split('@')[0] #ie all-students
      @mailing_lists << list.group_id #ie all-students@sv.cmu.edu
    end

    respond_to do |format|
      format.html
      format.xml { render :xml => @mailing_lists }
    end
  end


  # GET /mailing_lists/1
  # GET /mailing_lists/1.xml
  def show
    @mailing_list = params[:id]


#     (group, domain) = @mailing_list.split('@')
#     if(domain == "sv.cmu.edu")
#        @mailing_list = group + "@west.cmu.edu"
#     end
    @mailing_list = switch_sv_to_west(@mailing_list)

    @members = []
    google_apps_connection.retrieve_all_members(@mailing_list).each do |member|
      tmp = member.member_id
      @members << member.member_id
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @members }
    end

  rescue GDataError => e
    flash[:error] = "Mailing list does not exist"
  end


end
