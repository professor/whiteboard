class PageCommentTypesController < ApplicationController
  before_filter :authenticate_user!

  # GET /page_comment_types
  # GET /page_comment_types.xml
  def index
    @page_comment_types = PageCommentType.all
  end

  # GET /page_comment_types/1
  # GET /page_comment_types/1.xml
  def show
    @page_comment_type = PageCommentType.find(params[:id])
  end

  # GET /page_comment_types/new
  # GET /page_comment_types/new.xml
  def new
    if has_permissions_or_redirect(:staff, page_comment_types_url)

      @page_comment_type = PageCommentType.new
    end
  end

  # GET /page_comment_types/1/edit
  def edit
    if has_permissions_or_redirect(:staff, page_comment_types_url)
      @page_comment_type = PageCommentType.find(params[:id])
    end
  end

  # POST /page_comment_types
  # POST /page_comment_types.xml
  def create
    if has_permissions_or_redirect(:staff, page_comment_types_url)

      @page_comment_type = PageCommentType.new(params[:page_comment_type])

      respond_to do |format|
        if @page_comment_type.save
          flash[:notice] = 'PageCommentType was successfully created.'
          format.html { redirect_to(@page_comment_type) }
          format.xml { render :xml => @page_comment_type, :status => :created, :location => @page_comment_type }
        else
          format.html { render :action => "new" }
          format.xml { render :xml => @page_comment_type.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /page_comment_types/1
  # PUT /page_comment_types/1.xml
  def update
    if has_permissions_or_redirect(:staff, page_comment_types_url)
      @page_comment_type = PageCommentType.find(params[:id])

      respond_to do |format|
        if @page_comment_type.update_attributes(params[:page_comment_type])
          flash[:notice] = 'PageCommentType was successfully updated.'
          format.html { redirect_to(@page_comment_type) }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @page_comment_type.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /page_comment_types/1
  # DELETE /page_comment_types/1.xml
  def destroy
    if has_permissions_or_redirect(:admin, page_comment_types_url)
      @page_comment_type = PageCommentType.find(params[:id])
      @page_comment_type.destroy

      respond_to do |format|
        format.html { redirect_to(page_comment_types_url) }
        format.xml { head :ok }
      end
    end
  end
end
