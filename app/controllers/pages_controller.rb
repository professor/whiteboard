class PagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

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

    if @page.visible == false
      flash[:error] = "This page no longer exists."
      redirect_to(root_url) and return
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

    if @page.is_someone_else_currently_editing_page(current_user) && @page.timeout_has_not_passed


      flash[:notice] = "#{@page.current_edit_by.human_name} started editing this page
                        #{pluralize(((Time.now - @page.current_edit_started_at) / 1.minute).round, 'minute')} ago at
                        #{l @page.current_edit_started_at, :format => :detailed }"
      redirect_to(page_url) and return
    end

    @page.skip_version do
      @page.current_edit_by = current_user
      @page.current_edit_started_at = Time.now
      @page.save!
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

    respond_to do |format|
      format.html do
        update_page_edit_info(@page)
        if @page.update_attributes(params[:page])
          unless params[:timeout_flag].blank?
            flash[:notice] = "We thought you left, so we saved your page for you."
          else
            flash[:notice] = 'Page was successfully updated.'
          end

          redirect_to(@page)
        else
          render :action => "edit"
        end
      end

      format.xml do
        update_page_edit_info(@page)
        if @page.update_attributes(params[:page])
          head :ok
        else
          render :xml => @page.errors, :status => :unprocessable_entity
        end
      end

      format.json do
        # Do not bump up the version number for auto save
        @page.skip_version do
          if @page.update_attributes(params[:page])
            render :json => {:code => "success", :message => "", :new_post_path => page_path(@page)}
          else
            render :json => {:code => "failed", :message => "Automatic save failed"}
          end
        end
      end
    end
  end

  def revert
    @page = Page.find_by_url(params[:id])

    if @page.blank?
      flash[:error] = "Page with an id of #{params[:id]} is not in this system."
      redirect_to(pages_url) and return
    end

    unless @page.editable?(current_user)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(page_url) and return
    end

    respond_to do |format|
      if @page.revert_to! params[:version].to_i
        flash[:notice] = 'Page was successfully reverted.'
        format.html { redirect_to(@page) }
        format.xml { head :ok }
      else
        format.html { redirect_to page_path(@page, :history => true) }
        format.xml { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  def update_page_edit_info(page)
    page.updated_by_user_id = current_user.id if current_user
    page.current_edit_by = nil
    page.current_edit_started_at = nil
  end
end
