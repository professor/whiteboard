class SuggestionsController < ApplicationController
  layout 'cmu_sv'


  # GET /suggestions
  # GET /suggestions.xml
  def index
    @suggestions = Suggestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @suggestions }
    end
  end

  # GET /suggestions/1
  # GET /suggestions/1.xml
  def show
    @suggestion = Suggestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @suggestion }
    end
  end

  # GET /suggestions/new
  # GET /suggestions/new.xml
  def new
    @suggestion = Suggestion.new
    @suggestion.page = request.env["HTTP_REFERER"]

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @suggestion }
    end
  end

  # GET /suggestions/1/edit
  def edit
    @suggestion = Suggestion.find(params[:id])

  end

  # POST /suggestions
  # POST /suggestions.xml
  def create
    @suggestion = Suggestion.new(params[:suggestion])
    @suggestion.user_id = current_user.id if current_user
    page = @suggestion.page


    respond_to do |format|
      if @suggestion.save
        flash[:notice] = 'Thank you for your suggestion'
        format.html { redirect_to @suggestion.page }
        format.xml { render :xml => @suggestion, :status => :created, :location => @suggestion }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @suggestion.errors, :status => :unprocessable_entity }
      end
    end

    email_suggestion(@suggestion, "created")
  end

  # PUT /suggestions/1
  # PUT /suggestions/1.xml
  def update
    @suggestion = Suggestion.find(params[:id])

    respond_to do |format|
      if @suggestion.update_attributes(params[:suggestion])
        flash[:notice] = 'suggestion was successfully updated.'
        format.html { redirect_to(@suggestion) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @suggestion.errors, :status => :unprocessable_entity }
      end
    end

    email_suggestion(@suggestion, "updated")
  end

  # DELETE /suggestions/1
  # DELETE /suggestions/1.xml
  def destroy
    @suggestion = Suggestion.find(params[:id])
    @suggestion.destroy

    respond_to do |format|
      format.html { redirect_to(suggestions_url) }
      format.xml { head :ok }
    end
  end


  def email_suggestion(suggestion, status)

    message = "\"#{suggestion.comment}\"<br/><br/>"
    message = message + "by #{suggestion.user.human_name}" unless suggestion.user.nil?

    options = {:to => "todd.sedano@sv.cmu.edu",
               :subject => "Suggestion #{status}",
               :message => message,
               :url_label => "Show this suggestion",
               :url => "http://rails.sv.cmu.edu" + suggestion_path(suggestion)
    }
    GenericMailer.email(options).deliver

  end

end
