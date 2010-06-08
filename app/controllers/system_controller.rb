class SystemController < ApplicationController

  def index
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @effort_logs }
      end
  end

end
