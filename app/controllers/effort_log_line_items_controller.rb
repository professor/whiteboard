#
#
# Todo: consider removing this controller entirely.....
#
#
#
class EffortLogLineItemsController < ApplicationController
  # GET /effort_log_line_items
  # GET /effort_log_line_items.xml

  before_filter :redirect_to_effort_log_index

  def index
    @effort_log_line_items = EffortLogLineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @effort_log_line_items }
    end
  end

  # GET /effort_log_line_items/1
  # GET /effort_log_line_items/1.xml
  def show
    @effort_log_line_item = EffortLogLineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @effort_log_line_item }
    end
  end

  # GET /effort_log_line_items/new
  # GET /effort_log_line_items/new.xml
  def new
    @effort_log_line_item = EffortLogLineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @effort_log_line_item }
    end
  end

  # GET /effort_log_line_items/1/edit
  def edit

    @effort_log_line_item = EffortLogLineItem.find(params[:id])
  end

  # POST /effort_log_line_items
  # POST /effort_log_line_items.xml
  def create
    @effort_log_line_item = EffortLogLineItem.new(params[:effort_log_line_item])

    respond_to do |format|
      if @effort_log_line_item.save
        flash[:notice] = 'EffortLogLineItem was successfully created.'
        format.html { redirect_to(@effort_log_line_item) }
        format.xml { render :xml => @effort_log_line_item, :status => :created, :location => @effort_log_line_item }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @effort_log_line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /effort_log_line_items/1
  # PUT /effort_log_line_items/1.xml
  def update
    @effort_log_line_item = EffortLogLineItem.find(params[:id])

    respond_to do |format|
      if @effort_log_line_item.update_attributes(params[:effort_log_line_item])
        flash[:notice] = 'EffortLogLineItem was successfully updated.'
        format.html { redirect_to(@effort_log_line_item) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @effort_log_line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /effort_log_line_items/1
  # DELETE /effort_log_line_items/1.xml
  def destroy
    @effort_log_line_item = EffortLogLineItem.find(params[:id])
    @effort_log_line_item.destroy

    respond_to do |format|
      format.html { redirect_to(effort_log_line_items_url) }
      format.xml { head :ok }
    end
  end

  protected
  def redirect_to_effort_log_index
    redirect_to :controller => :effort_logs, :action => :index
  end
end
