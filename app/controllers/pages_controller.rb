class PagesController < ApplicationController
  before_filter :require_user

  layout 'cmu_sv_no_pad'

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find_by_url(params[:id])
    @page.revert_to(params[:version].to_i) if params[:version]

    @tab = params[:tab]

    respond_to do |format|
      if @page.nil?
        flash[:error] = "Page with an id of #{params[:id]} is not in this system."
        format.html { redirect_to(pages_url) }
        format.xml { render :xml => @person.errors, :status => :unprocessable_entity }
      else
        format.html # show.html.erb
        format.xml { render :xml => @page }
      end
    end
  end

  # GET /pages/new
  # GET /pages/new.xml
  def new
    @page = Page.new
    @page.course_id = params[:course_id].to_i
#    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.cwyear, ApplicationController.current_semester()] )
    @courses = Course.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find_by_url(params[:id])

    unless @page.editable?(current_user)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(page_url) and return
    end
    

#    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.cwyear, ApplicationController.current_semester()] )
    @courses = Course.find(:all)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @page }
    end    
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])
#    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.cwyear, ApplicationController.current_semester()] )
    @courses = Course.find(:all)
    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to(@page) }
        format.xml  { render :xml => @page, :status => :created, :location => @page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find_by_url(params[:id])

    unless @page.editable?(current_user)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(page_url) and return
    end

#    @courses = Course.find(:all, :conditions => ['year = ? and semester = ?', Date.today.cwyear, ApplicationController.current_semester()] )
    @courses = Course.find(:all)

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to(@page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @page.errors, :status => :unprocessable_entity }
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
