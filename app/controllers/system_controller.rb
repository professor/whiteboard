class SystemController < ApplicationController

  def index
    @current_user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @effort_logs }
    end
  end

end
