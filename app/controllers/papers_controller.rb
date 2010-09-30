class PapersController < ApplicationController

  layout 'cmu_sv'


  # GET /papers
  # GET /papers.xml
  def index
    @papers = Paper.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @papers }
    end
  end

  # GET /papers/1
  # GET /papers/1.xml
  def show
    @paper = Paper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/new
  # GET /papers/new.xml
  def new
    @paper = Paper.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  def new_tmp
    @paper = Paper.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @paper }
    end
  end

  # GET /papers/1/edit
  def edit
    @paper = Paper.find(params[:id])
  end

  def edit_tmp
    @paper = Paper.find(params[:id])
  end


  # POST /papers
  # POST /papers.xml
  def create
    @paper = Paper.new(params[:paper])

    respond_to do |format|
      if @paper.save
        flash[:notice] = 'Paper was successfully created.'
        format.html { redirect_to(papers_url) }
        format.xml  { render :xml => @paper, :status => :created, :location => @paper }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /papers/1
  # PUT /papers/1.xml
  def update
    @paper = Paper.find(params[:id])
    msg = @paper.update_authors(params[:people])
    unless msg.blank?
      flash[:error] = msg
      redirect_to :action => 'edit'
      return      
    end
    
    respond_to do |format|
      if @paper.update_attributes(params[:paper])
        flash[:notice] = 'Paper was successfully updated.'
        format.html { redirect_to(papers_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @paper.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /papers/1
  # DELETE /papers/1.xml
  def destroy
    @paper = Paper.find(params[:id])
    @paper.destroy

    respond_to do |format|
      format.html { redirect_to(papers_url) }
      format.xml  { head :ok }
    end
  end
end
