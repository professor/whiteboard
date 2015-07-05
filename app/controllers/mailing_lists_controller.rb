require 'google_wrapper'

class MailingListsController < ApplicationController
  before_filter :authenticate_user!

  layout 'cmu_sv'

  # GET /mailing_lists
  # GET /mailing_lists.xml
  def index
    @mailing_lists = []
    GoogleWrapper.retrieve_all_groups.each do |list|
      @mailing_lists << list.email #ie all-students@sv.cmu.edu
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

    @mailing_list = switch_sv_to_west(@mailing_list)

    @members = []
    GoogleWrapper.retrieve_all_members(@mailing_list).each do |member|
      @members << member.email
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @members }
    end

  rescue Google::Apis::ClientError => e
    flash[:error] = 'There was an error'
  end


end
