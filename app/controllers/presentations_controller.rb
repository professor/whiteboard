class PresentationsController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  def index_for_course
    @course = Course.find(params[:course_id])
    if (current_person.is_admin? || @course.faculty.include?(current_person))
      @presentations = Presentation.find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  # GET /presentations/new
  # GET /presentations/new.xml
  def new
    @presentation = Presentation.new
    @course =Course.find_by_id(params[:course_id])
  end

  # POST /presentations
  # POST /presentations.xml
  def create
    owner_id = Person.find_by_human_name(params[:presentation][:owner]) unless params[:presentation][:owner].nil?
    @presentation= Presentation.new(:owner_id=>owner_id,
                                    :name=>params[:presentation][:name],
                                    :team_id=>params[:presentation][:team_id],
                                    :present_date=>params[:presentation][:present_date],
                                    :task_number=>params[:presentation][:task_number],
                                    :course_id=>params[:course_id])
    respond_to do |format|
       if @presentation.save
            format.html { redirect_to( course_presentations_path, :course_id=>params[:course_id], :notice => 'Successfully created the Presentation.') }
       else
           format.html { render :action => "new" }
       end
    end
  end
end
