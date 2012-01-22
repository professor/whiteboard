class PageAttachmentsController < ApplicationController
  def update
    @pa = PageAttachment.find(params[:id])

    if @pa.page.editable?(current_user)
      respond_to do |format|
        if @pa.update_attributes(params[:page_attachment])
          format.html { redirect_to @pa.page }
        else
          flash[:error] = 'Could not upload your file.'
          format.html { redirect_to @pa.page }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to @pa.page
    end

  end

  def create
    @pa = PageAttachment.new params[:page_attachment]

    if @pa.page.editable?(current_user)
      respond_to do |format|
        if @pa.page_attachment.present? && @pa.save
          format.html { redirect_to @pa.page }
        else
          flash[:error] = 'Could not upload your file.'
          format.html { redirect_to @pa.page }
        end
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to @pa.page
    end
  end

  def destroy
    @pa = PageAttachment.find(params[:id])

    if @pa.page.editable?(current_user)
      @pa.destroy
      flash[:notice] = "Page attachment successfully deleted."

      respond_to do |format|
        format.html { redirect_to @pa.page }
      end
    else
      flash[:error] = "You don't have permission to do that."
      redirect_to @pa.page
    end
  end
end
