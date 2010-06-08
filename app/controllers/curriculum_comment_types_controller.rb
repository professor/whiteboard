class CurriculumCommentTypesController < ApplicationController
  before_filter :login_required

  # GET /curriculum_comment_types
  # GET /curriculum_comment_types.xml
  def index
    @curriculum_comment_types = CurriculumCommentType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @curriculum_comment_types }
    end
  end

  # GET /curriculum_comment_types/1
  # GET /curriculum_comment_types/1.xml
  def show
    @curriculum_comment_type = CurriculumCommentType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @curriculum_comment_type }
    end
  end

  # GET /curriculum_comment_types/new
  # GET /curriculum_comment_types/new.xml
  def new
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(curriculum_comment_types_url) and return
    end

    @curriculum_comment_type = CurriculumCommentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @curriculum_comment_type }
    end
  end

  # GET /curriculum_comment_types/1/edit
  def edit
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(curriculum_comment_type_url) and return
    end 
    @curriculum_comment_type = CurriculumCommentType.find(params[:id])
  end

  # POST /curriculum_comment_types
  # POST /curriculum_comment_types.xml
  def create
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(curriculum_comment_types_url) and return
    end

    @curriculum_comment_type = CurriculumCommentType.new(params[:curriculum_comment_type])

    respond_to do |format|
      if @curriculum_comment_type.save
        flash[:notice] = 'CurriculumCommentType was successfully created.'
        format.html { redirect_to(@curriculum_comment_type) }
        format.xml  { render :xml => @curriculum_comment_type, :status => :created, :location => @curriculum_comment_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @curriculum_comment_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /curriculum_comment_types/1
  # PUT /curriculum_comment_types/1.xml
  def update
    if !(current_user.is_admin? || current_user.is_staff?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(curriculum_comment_type_url) and return
    end
    @curriculum_comment_type = CurriculumCommentType.find(params[:id])

    respond_to do |format|
      if @curriculum_comment_type.update_attributes(params[:curriculum_comment_type])
        flash[:notice] = 'CurriculumCommentType was successfully updated.'
        format.html { redirect_to(@curriculum_comment_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @curriculum_comment_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /curriculum_comment_types/1
  # DELETE /curriculum_comment_types/1.xml
  def destroy
    if !(current_user.is_admin?)
      flash[:error] = "You don't have permission to do this action."
      redirect_to(curriculum_comment_type_url) and return
    end 
    @curriculum_comment_type = CurriculumCommentType.find(params[:id])
    @curriculum_comment_type.destroy

    respond_to do |format|
      format.html { redirect_to(curriculum_comment_types_url) }
      format.xml  { head :ok }
    end
  end
end
