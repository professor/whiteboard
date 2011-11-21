class PresentationsController < ApplicationController

  layout 'cmu_sv'

  before_filter :authenticate_user!

  # GET /presentations
  # GET /presentations.xml
  def index
    redirect_to my_presentations_path(current_user)
  end

  def my_presentations
    person = Person.find(params[:id])
    if (current_user.id != person.id)
      unless (current_person.is_staff?)||(current_user.is_admin?)
        flash[:error] = I18n.t(:not_your_presentation)
        redirect_to root_path
        return
      end
    end
    @presentations = Presentation.find_by_person(person)
    if (person.is_staff? || person.is_admin?)
      @created_presentations = Presentation.find_all_by_creator_id(person.id)
    end

    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @presentations }
    end
  end

  # GET /presentations/1
  # GET /presentations/1.xml
  def show
    @presentation = Presentation.find(params[:id])

    unless @presentation.editable?(current_user)
      flash[:error] = I18n.t(:not_your_presentation)
      redirect_to root_path and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @presentation }
    end
  end

  # GET /presentations/new
  # GET /presentations/new.xml
  def new
    if(current_user.is_staff? || current_user.is_admin?)
      @presentation = Presentation.new(:creator => current_person)

      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @presentation }
      end
    else
      flash[:error] = I18n.t(:no_permission)
      redirect_to root_path
    end
  end

  # GET /presentations/1/edit
  def edit
    @presentation = Presentation.find(params[:id])

    unless @presentation.editable?(current_user)
      flash[:error] = I18n.t(:not_your_presentation)
      redirect_to root_path and return
    end
  end

  # POST /presentations
  # POST /presentations.xml
  def create
    @presentation = Presentation.new(params[:presentation])
    @presentation.creator = current_person
    if !params[:presentation][:presentation]
      flash[:error] = 'Must specify a file to upload'
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml { render :xml => @presentation.errors, :status => :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @presentation.valid? and @presentation.save
        flash[:notice] = 'Presentation was successfully created.'
        format.html { redirect_to(@presentation) }
        format.xml { render :xml => @presentation, :status => :created, :location => @presentation }
      else
        if not @presentation.valid?
          flash[:notice] = 'Presentation not valid'
        else
          flash[:notice] = 'Something else went wrong'
        end
        format.html { render :action => "new" }
        format.xml { render :xml => @presentation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /presentations/1
  # PUT /presentations/1.xml
  def update
    @presentation = Presentation.find(params[:id])

    unless @presentation.editable?(current_user)
      flash[:error] = I18n.t(:not_your_presentation)
      redirect_to root_path and return
    end

    if @presentation.valid? and @presentation.update_attributes(params[:presentation])
      flash[:notice] = 'Presentation was successfully updated.'
      redirect_to(@presentation)
    else
      render :action => "edit"
    end
  end

  # DELETE /presentations/1
  # DELETE /presentations/1.xml
  def destroy
    @presentation = Presentation.find(params[:id])

    unless @presentation.editable?(current_user)
      flash[:error] = I18n.t(:not_your_presentation)
      redirect_to root_path and return
    end
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to(presentations_url) }
      format.xml { head :ok }
    end
  end

  def index_for_feedback
    if current_user.is_student?
      team_id = Team.find_by_person(current_user)
      @presentations = Presentation.where(
        "(team_id is Null AND user_id != :id) OR (team_id is not Null AND team_id != :team_id)",
        {:id => current_user.id, :team_id => team_id})
    else
      @presentations = Presentation.all
    end

    @current_user = current_user

  end
end
