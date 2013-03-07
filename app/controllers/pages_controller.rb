class PagesController < ApplicationController
  before_filter :authenticate_user!

#  layout 'cmu_sv_no_pad'
  layout 'cmu_sv'

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @pages }
    end
  end

  def changed
    @pages = Page.order("updated_at DESC").all
    @no_pad = true

    respond_to do |format|
      format.html
      format.xml { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @no_pad = true
    @page = Page.find_by_url(params[:id])
    @page.revert_to(params[:version].to_i) if params[:version]

    if @page.blank?
      flash[:error] = "Page with an id of #{params[:id]} is not in this system. You may create it using the form below."
      redirect_to(:controller => :pages, :action => :new, :url => params[:id]) and return
    end

    unless @page.viewable?(current_user)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(root_url) and return
    end

    @tab = params[:tab]

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    @page.title = params[:url].split('_').collect { |w| w.capitalize + ' ' }.join().chomp(' ') if params[:url]
    @page.url = params[:url]
    @page.course_id = params[:course_id].to_i
#    @courses = Course.all
    @courses = Course.unique_course_names

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find_by_url(params[:id])
    @courses = Course.unique_course_names

    if @page.blank?
      flash[:error] = "Page with an id of #{params[:id]} is not in this system."
      redirect_to(pages_url) and return
    end

    unless @page.editable?(current_user)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(page_url) and return
    end

    now = Time.now
    if @page.updater_user_id.nil? ||
        @page.updating_started_at.nil?||
        ((now - @page.updating_started_at) / 1.minute).round >= 30 ||
        @page.updater_user_id == current_user.id
      @page.updater_user_id=current_user.id
      @page.updating_started_at=now
      @page.save!
    else
      flash[:notice] = "#{@page.current_updater.human_name} started editing this page
                        #{pluralize(((now - @page.updating_started_at) / 1.minute).round, 'minute')} ago at
                       '#{@page.updating_started_at.getlocal.strftime('%Y-%m-%d %I:%M:%S %p')}'"
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @page }
    end
  end

  def pluralize(number, text)
    return number.to_s+' '+text.pluralize if number != 1
    number.to_s+' '+text
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
#    @courses = Course.all
    @courses = Course.unique_course_names

    @page.updated_by_user_id = current_user.id if current_user
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find_by_url(params[:id])
    @courses = Course.unique_course_names

    unless @page.editable?(current_user)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(page_url) and return
    end

    #course = Course.with_course_name(params[:course_name]).first
    #@page.course = course

    @page.updated_by_user_id = current_user.id if current_user

    #only reset the editor if the person saving the changes was the person that started updating
    if @page.updated_by_user_id==@page.updater_user_id
      @page.updater_user_id=nil
    end

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  #  def destroy
  #    @page = Page.find(params[:id])
  #    @page.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to(pages_url) }
  #      format.xml  { head :ok }
  #    end
  #  end
end
