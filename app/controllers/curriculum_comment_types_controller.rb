class CurriculumCommentTypesController < ApplicationController
  before_filter :authenticate_user!

  # GET /curriculum_comment_types
  # GET /curriculum_comment_types.xml
  def index
    @curriculum_comment_types = CurriculumCommentType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @curriculum_comment_types }
    end
  end

  # GET /curriculum_comment_types/1
  # GET /curriculum_comment_types/1.xml
  def show
    @curriculum_comment_type = CurriculumCommentType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @curriculum_comment_type }
    end
  end

  # GET /curriculum_comment_types/new
  # GET /curriculum_comment_types/new.xml
  def new
    if has_permissions_or_redirect(:staff, curriculum_comment_types_url)

      @curriculum_comment_type = CurriculumCommentType.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml { render :xml => @curriculum_comment_type }
      end
    end
  end

  # GET /curriculum_comment_types/1/edit
  def edit
    if has_permissions_or_redirect(:staff, curriculum_comment_types_url)
      @curriculum_comment_type = CurriculumCommentType.find(params[:id])
    end
  end

  # POST /curriculum_comment_types
  # POST /curriculum_comment_types.xml
  def create
    if has_permissions_or_redirect(:staff, curriculum_comment_types_url)

      @curriculum_comment_type = CurriculumCommentType.new(params[:curriculum_comment_type])

      respond_to do |format|
        if @curriculum_comment_type.save
          flash[:notice] = 'CurriculumCommentType was successfully created.'
          format.html { redirect_to(@curriculum_comment_type) }
          format.xml { render :xml => @curriculum_comment_type, :status => :created, :location => @curriculum_comment_type }
        else
          format.html { render :action => "new" }
          format.xml { render :xml => @curriculum_comment_type.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /curriculum_comment_types/1
  # PUT /curriculum_comment_types/1.xml
  def update
    if has_permissions_or_redirect(:staff, curriculum_comment_types_url)
      @curriculum_comment_type = CurriculumCommentType.find(params[:id])

      respond_to do |format|
        if @curriculum_comment_type.update_attributes(params[:curriculum_comment_type])
          flash[:notice] = 'CurriculumCommentType was successfully updated.'
          format.html { redirect_to(@curriculum_comment_type) }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @curriculum_comment_type.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /curriculum_comment_types/1
  # DELETE /curriculum_comment_types/1.xml
  def destroy
    if has_permissions_or_redirect(:admin, curriculum_comment_types_url)
      @curriculum_comment_type = CurriculumCommentType.find(params[:id])
      @curriculum_comment_type.destroy

      respond_to do |format|
        format.html { redirect_to(curriculum_comment_types_url) }
        format.xml { head :ok }
      end
    end
  end
end
