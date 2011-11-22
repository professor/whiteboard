class PresentationFeedbacksController < ApplicationController
  layout 'cmu_sv'
  before_filter :authenticate_user!

  # GET /presentation_feedbacks
  # GET /presentation_feedbacks.xml
  def index
    redirect_to :controller => 'presentations', :action => 'index_for_feedback'

  end

  def show_for_presentation
    @presentation_feedback = PresentationFeedback.where("user_id = :uid AND presentation_id = :pid",
        {:uid => current_user.id, :pid => params[:id]}).first
    redirect_to :action => 'show', :id => @presentation_feedback.id
  end

  # GET /presentation_feedbacks/1
  # GET /presentation_feedbacks/1.xml
  def show
    @presentation_feedback = PresentationFeedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @presentation_feedback }
    end
  end

  # GET /presentation_feedbacks/:id/new
  # GET /presentation_feedbacks/:id/new.xml
  def new


    @presentation_feedbacks = PresentationFeedback.where("user_id = :uid AND presentation_id = :pid",
          {:uid => current_user.id, :pid => params[:id]})

    if @presentation_feedbacks[0] == nil
      @presentation_feedback = PresentationFeedback.new
      @presentation_feedback.presentation_id = params[:id]
    else
      redirect_to :action => 'edit',:id => @presentation_feedbacks[0].id and return
    end


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @presentation_feedback }
    end
  end

  # GET /presentation_feedbacks/1/edit
  def edit
    @presentation_feedback = PresentationFeedback.find(params[:id])
  end

  # POST /presentation_feedbacks
  # POST /presentation_feedbacks.xml
  def create
    @presentation_feedback = PresentationFeedback.new(params[:presentation_feedback])

    @presentation_feedback.user_id = current_user.id

    respond_to do |format|
      if @presentation_feedback.save
        format.html { redirect_to(@presentation_feedback, :notice => 'Presentation feedback was successfully created.') }
        format.xml  { render :xml => @presentation_feedback, :status => :created, :location => @presentation_feedback }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @presentation_feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /presentation_feedbacks/1
  # PUT /presentation_feedbacks/1.xml
  def update
    @presentation_feedback = PresentationFeedback.find(params[:id])

    respond_to do |format|
      if @presentation_feedback.update_attributes(params[:presentation_feedback])
        format.html { redirect_to(@presentation_feedback, :notice => 'Presentation feedback was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @presentation_feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /presentation_feedbacks/1
  # DELETE /presentation_feedbacks/1.xml
  def destroy
    @presentation_feedback = PresentationFeedback.find(params[:id])
    @presentation_feedback.destroy

    respond_to do |format|
      format.html { redirect_to(presentation_feedbacks_url) }
      format.xml  { head :ok }
    end
  end
end
