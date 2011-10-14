class WelcomeController < ApplicationController
#  layout 'cmu_sv_simple'
  layout 'cmu_sv'

  def index
    @rss_feeds = RssFeed.all

    if (current_person.nil?)
      @courses_registered_as_student = []
    else
      @courses_registered_as_student = current_person.get_registered_courses
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @courses }
    end
  end

  def new_features

  end

  def configuration

  end

end
