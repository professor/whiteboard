class PageAttachmentsController < ApplicationController
  layout 'cmu_sv'

  def new
    @page_attachment = PageAttachment.new(:page_id => params[:page])
  end
  def create
     @page_attachment = PageAttachment.new(params[:page_attachment])

    if @page_attachment.attachment.nil?
      flash[:error] = 'Must specify a file to upload'
      respond_to do |format|
        format.html { render :action => "new" }
      end
      return
    end
    @page = Page.find(@page_attachment.page_id)
    @page.page_attachments << @page_attachment

    respond_to do |format|
      if @page_attachment.valid? and @page_attachment.save
        flash[:notice] = 'Attachment was successfully added.'
        format.html { redirect_to(@page) }
        format.xml { render :xml => @page_attachment, :status => :created, :location => @page_attachment }
      else
        if not @page_attachment.valid?
          flash[:notice] = 'Attachment not valid'
        else
          flash[:notice] = 'Something went wrong'
        end
        format.html { render :action => "new" }
        format.xml { render :xml => @page_attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @page_attachment = PageAttachment.find(params[:id])

    unless @page_attachment.page.editable?(current_user)
      flash[:error] = "You do not have the permission to edit this."
      redirect_to @page_attachment.page and return
    end

  end

  def update
    @page_attachment = PageAttachment.find(params[:id])

    unless @page_attachment.page.editable?(current_user)
      flash[:error] = "You do not have the permission to edit this."
      redirect_to @page_attachment.page and return
    end


    if @page_attachment.update_attributes(params[:page_attachment])
        flash[:notice] = 'Attachment was successfully updated.'
        redirect_to(@page_attachment.page)
      else
        render :action => "edit"
      end
  end
end
