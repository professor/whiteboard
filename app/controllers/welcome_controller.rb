class WelcomeController < ApplicationController
  layout 'cmu_sv'

  def index
    @rss_feeds = RssFeed.all

    if (current_person.nil?)
      @registered_for_these_courses_during_current_semester = []
      @teaching_these_courses_during_current_semester = []
    else
      @registered_for_these_courses_during_current_semester = current_person.registered_for_these_courses_during_current_semester
      @teaching_these_courses_during_current_semester = current_person.teaching_these_courses_during_current_semester
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
