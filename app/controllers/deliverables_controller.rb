class DeliverablesController < ApplicationController

  layout 'cmu_sv'
  
  # GET /deliverables
  # GET /deliverables.xml
  def index
    @deliverables = Deliverable.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deliverables }
    end
  end

  def my_deliverables
    redirect_to :action => "index"
  end

  # GET /deliverables/1
  # GET /deliverables/1.xml
  def show
    @deliverable = Deliverable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deliverables }
    end
  end

  # GET /deliverables/new
  # GET /deliverables/new.xml
  def new
    @deliverable = Deliverable.new(:creator => Person.find(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deliverable }
    end
  end

  # GET /deliverables/1/edit
  def edit
    @deliverable = Deliverable.find(params[:id])
  end

  # POST /deliverables
  # POST /deliverables.xml
  def create
    @deliverable = Deliverable.new(params[:deliverable])
    @deliverable.creator = Person.find(current_user)
    @revision = DeliverableRevision.new(params[:deliverable_revision])
    @revision.submitter = @deliverable.creator
    @deliverable.current_revision = @revision

    respond_to do |format|
      if @revision.valid? and @deliverable.valid? and @deliverable.save
        flash[:notice] = 'Deliverable was successfully created.'
        format.html { redirect_to(@deliverable) }
        format.xml  { render :xml => @deliverable, :status => :created, :location => @deliverable }
      else
        if not @revision.valid?
          flash[:notice] = 'Revision not valid'
        elsif not @deliverable.valid?
          flash[:notice] = 'Deliverable not valid'
        else
          flash[:notice] = 'Something else went wrong'          
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deliverables/1
  # PUT /deliverables/1.xml
  def update
    @deliverable_parent = DeliverableRevision.find(params[:id])
    @deliverable = DeliverableRevision.new(params[:deliverable])
    @deliverable.submitter = Person.find(current_user)
    @deliverable.parent_id = @deliverable_parent.id

    respond_to do |format|
      if @deliverable.save
        flash[:notice] = 'Deliverable was successfully updated.'
        format.html { redirect_to(@deliverable_parent) }
        format.xml  { render :xml => @deliverable_parent, :status => :created, :location => @deliverable_parent }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deliverable_parent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deliverables/1
  # DELETE /deliverables/1.xml
  def destroy
    @deliverable = DeliverableRevision.find(params[:id])
    @deliverable.destroy

    respond_to do |format|
      format.html { redirect_to(deliverables_url) }
      format.xml  { head :ok }
    end
  end
end
