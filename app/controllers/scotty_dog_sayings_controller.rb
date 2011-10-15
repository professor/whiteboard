class ScottyDogSayingsController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  # GET /scotty_dog_sayings
  # GET /scotty_dog_sayings.xml
  def index
    @scotty_dog_sayings = ScottyDogSaying.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @scotty_dog_sayings }
    end
  end

  # GET /scotty_dog_sayings/1
  # GET /scotty_dog_sayings/1.xml
  def show
    @scotty_dog_saying = ScottyDogSaying.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @scotty_dog_saying }
    end
  end

  # GET /scotty_dog_sayings/new
  # GET /scotty_dog_sayings/new.xml
  def new
    @scotty_dog_saying = ScottyDogSaying.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @scotty_dog_saying }
    end
  end

  # GET /scotty_dog_sayings/1/edit
  def edit
    @scotty_dog_saying = ScottyDogSaying.find(params[:id])
  end

  # POST /scotty_dog_sayings
  # POST /scotty_dog_sayings.xml
  def create
    @scotty_dog_saying = ScottyDogSaying.new(params[:scotty_dog_saying])
    @scotty_dog_saying.user_id = current_user.id if current_user

    respond_to do |format|
      if @scotty_dog_saying.save
        flash[:notice] = 'Thank you for adding to my reprotoire. Scotty Dog Saying was successfully created.'
        format.html { redirect_to(scotty_dog_sayings_path) }
        format.xml { render :xml => @scotty_dog_saying, :status => :created, :location => @scotty_dog_saying }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @scotty_dog_saying.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scotty_dog_sayings/1
  # PUT /scotty_dog_sayings/1.xml
  def update
    @scotty_dog_saying = ScottyDogSaying.find(params[:id])

    respond_to do |format|
      if @scotty_dog_saying.update_attributes(params[:scotty_dog_saying])
        flash[:notice] = 'Thanks for giving me something better to say. Scotty Dog Saying was successfully updated.'
        format.html { redirect_to(scotty_dog_sayings_path) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @scotty_dog_saying.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scotty_dog_sayings/1
  # DELETE /scotty_dog_sayings/1.xml
  def destroy
    @scotty_dog_saying = ScottyDogSaying.find(params[:id])
    @scotty_dog_saying.destroy

    respond_to do |format|
      format.html { redirect_to(scotty_dog_sayings_url) }
      format.xml { head :ok }
    end
  end
end
