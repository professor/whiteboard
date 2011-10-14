class CurriculumCommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :new, :create, :test_page]
#  protect_from_forgery :only => [:create, :update, :destroy] #if the ajax load comes from http://curriculum to https://curriculum then this InvalidAuthenticityToken gets triggered. When pubcookie is functioning on curriculum again, we should be able reo remove this line of code.

# GET /curriculum_comments
# GET /curriculum_comments.xml
  def index
    url = get_http_referer()
    @curriculum_comments = CurriculumComment.where("url = ? and semester = ? and year = ?", url, AcademicCalendar.current_semester(), Date.today.year.to_s)
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @curriculum_comments }
    end
  end

  # GET /curriculum_comments/1
  # GET /curriculum_comments/1.xml
  def show
    @curriculum_comment = CurriculumComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @curriculum_comment }
    end
  end

  # GET /curriculum_comments/new
  # GET /curriculum_comments/new.xml
  def new
    redirect_to :action => 'robots' if robot?
    url = get_http_referer()
    @curriculum_comment = CurriculumComment.new
    @curriculum_comment.url = url
    @curriculum_comment.notify_me = true if current_user
    @types = CurriculumCommentType.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @curriculum_comment }
    end
  end

  # GET /curriculum_comments/1/edit
  def edit
    @curriculum_comment = CurriculumComment.find(params[:id])
    @types = CurriculumCommentType.all
  end

  # POST /curriculum_comments
  # POST /curriculum_comments.xml
  def create
    @curriculum_comment = CurriculumComment.new(params[:curriculum_comment])
    @curriculum_comment.user_id = current_user.id if current_user
    @curriculum_comment.semester = AcademicCalendar.current_semester()
    @curriculum_comment.year = Date.today.year
    @types = CurriculumCommentType.all

    respond_to do |format|
      if @curriculum_comment.save
        a = CurriculumCommentMailer.comment_update(@curriculum_comment, "created")
        a.deliver
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@curriculum_comment.url) }
        format.xml { render :xml => @curriculum_comment, :status => :created, :location => @curriculum_comment }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @curriculum_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /curriculum_comments/1
  # PUT /curriculum_comments/1.xml
  def update
    @curriculum_comment = CurriculumComment.find(params[:id])
    if editable_or_redirect(@curriculum_comment, @curriculum_comment.url)
      @types = CurriculumCommentType.all

      respond_to do |format|
        if @curriculum_comment.update_attributes(params[:curriculum_comment])
          CurriculumCommentMailer.comment_update(@curriculum_comment, "updated").deliver
          flash[:notice] = 'Comment was successfully updated.'
          format.html { redirect_to(@curriculum_comment.url) }
          format.xml { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml { render :xml => @curriculum_comment.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /curriculum_comments/1
  # DELETE /curriculum_comments/1.xml
  def destroy
    @curriculum_comment = CurriculumComment.find(params[:id])
    if has_permissions_or_redirect(:admin, @curriculum_comment.url)
      @curriculum_comment.destroy

      respond_to do |format|
        format.html { redirect_to(curriculum_comments_url) }
        format.xml { head :ok }
      end
    end
  end

  def robots
    logger.info("curriculum comment: robot detected")
    format.html # index.html.erb
  end

  def test_page

    respond_to do |format|
      format.html # index.html.erb
                  #      format.xml  { render :xml => @effort_logs }
    end
    #    render(:text => "E-Mail sent")
  end

end
