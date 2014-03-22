class PageCommentsController < ApplicationController
  before_filter :authenticate_user!

# This would happen on the page show
#  def index
#    page = Page.find(params[:id])
#    @page_comments = PageComment.where("page_id = ? and semester = ? and year = ?", page.id, AcademicCalendar.current_semester(), Date.today.year.to_s)
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml { render :xml => @page_comments }
#    end
#  end

  # GET /page_comments/1
  # GET /page_comments/1.xml
  def show
    @page_comment = PageComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @page_comment }
    end
  end

  # GET /page_comments/new
  # GET /page_comments/new.xml
  def new
    @page_comment = PageComment.new
    @page_comment.notify_me = true if current_user
    @types = PageCommentType.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @page_comment }
    end
  end

  # GET /page_comments/1/edit
  def edit
    @page_comment = PageComment.find(params[:id])
    @types = PageCommentType.all
  end

  # POST /page_comments
  # POST /page_comments.xml
  def create
    @page_comment = PageComment.new(params[:page_comment])
    @page_comment.user_id = current_user.id if current_user
    @page_comment.semester = AcademicCalendar.current_semester()
    @page_comment.year = Date.today.year
    @types = PageCommentType.all

    respond_to do |format|
      if @page_comment.save
        a = PageCommentMailer.comment_update(@page_comment, "created")
        a.deliver
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@page_comment.url) }
        format.xml { render :xml => @page_comment, :status => :created, :location => @page_comment }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @page_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /page_comments/1
  # PUT /page_comments/1.xml
  def update
    @page_comment = PageComment.find(params[:id])
    unless @page_comment.editable?(current_user)
      flash[:error] = I18n.t(:no_permission)
      redirect_to(@page_comment.url) and return
    end
    @types = PageCommentType.all

    respond_to do |format|
      if @page_comment.update_attributes(params[:page_comment])
        PageCommentMailer.comment_update(@page_comment, "updated").deliver
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@page_comment.url) }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @page_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /page_comments/1
  # DELETE /page_comments/1.xml
  def destroy
    @page_comment = PageComment.find(params[:id])
    if has_permissions_or_redirect(:admin, @page_comment.url)
      @page_comment.destroy

      respond_to do |format|
        format.html { redirect_to(page_comments_url) }
        format.xml { head :ok }
      end
    end
  end


end
