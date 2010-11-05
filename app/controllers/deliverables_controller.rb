class DeliverablesController < ApplicationController

  layout 'cmu_sv'
  
  before_filter :require_user

  # GET /deliverables
  # GET /deliverables.xml
  def index
    redirect_to my_deliverables_path(current_user)
  end

  def my_deliverables
    person = Person.find(params[:id])
    if (current_user.id != person.id)
      unless (current_user.is_staff?)||(current_user.is_admin?)
        flash[:error] = "You don't have permission to see another person's deliverables."
        redirect_to :controller => "welcome", :action => "index"
        return
      end
    end
    @current_deliverables = Deliverable.find_current_by_person(person)
    @past_deliverables = Deliverable.find_past_by_person(person)

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml  { render :xml => @deliverables }
    end
  end

  # GET /deliverables/1
  # GET /deliverables/1.xml
  def show
    @deliverable = Deliverable.find(params[:id])

    # If we aren't on this deliverable's team, you can't see it.
    if !Team.find_by_person(Person.find(current_user)).find(@deliverable.team)
      flash[:error] = "You don't have permission to see another team's deliverables."
      redirect_to :controller => "welcome", :action => "index"
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deliverables }
    end
  end

  # GET /deliverables/new
  # GET /deliverables/new.xml
  def new
    # If we aren't on this deliverable's team, you can't see it.
    @deliverable = Deliverable.new(:creator => Person.find(current_user))

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deliverable }
    end
  end

  # GET /deliverables/1/edit
  def edit
    @deliverable = Deliverable.find(params[:id])
    cur_person = Person.find(current_user)
    if !Team.find_by_person(cur_person).find(@deliverable.team)
      flash[:error] = "You don't have permission to edit another team's deliverables."
      redirect_to :controller => "welcome", :action => "index"
      return
    end
  end

  # POST /deliverables
  # POST /deliverables.xml
  def create
    # Make sure that a file was specified
    @deliverable = Deliverable.new(params[:deliverable])
    @deliverable.creator = Person.find(current_user)
    if !params[:deliverable_revision][:revision]
      flash[:error] = 'Must specify a file to upload'
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
      return
    end
    @revision = DeliverableRevision.new(params[:deliverable_revision])
    @revision.submitter = @deliverable.creator
    @deliverable.revisions << @revision
    @revision.deliverable = @deliverable

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
    @deliverable = Deliverable.find(params[:id])
    cur_person = Person.find(current_user)
    if !Team.find_by_person(cur_person).find(@deliverable.team)
      flash[:error] = "You don't have permission to edit another team's deliverables."
      redirect_to :controller => "welcome", :action => "index"
      return
    end
    
    @revision = DeliverableRevision.new(params[:deliverable_revision])
    @revision.submitter = Person.find(current_user)
    @deliverable.revisions << @revision
    @revision.deliverable = @deliverable

    respond_to do |format|
      if @revision.valid? and @deliverable.valid? and @deliverable.save
        flash[:notice] = 'Deliverable was successfully updated.'
        format.html { redirect_to(@deliverable) }
        format.xml  { render :xml => @deliverable, :status => :created, :location => @deliverable }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deliverable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deliverables/1
  # DELETE /deliverables/1.xml
  def destroy
    @deliverable = Deliverable.find(params[:id])
    cur_person = Person.find(current_user)
    if !Team.find_by_person(cur_person).find(@deliverable.team)
      flash[:error] = "You don't have permission to delete another team's deliverables."
      redirect_to :controller => "welcome", :action => "index"
      return
    end
    @deliverable.destroy

    respond_to do |format|
      format.html { redirect_to(deliverables_url) }
      format.xml  { head :ok }
    end
  end
end
