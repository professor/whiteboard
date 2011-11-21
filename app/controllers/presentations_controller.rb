class PresentationsController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  @@eval_options = {
      1 => "Poor",
      2 => "Minimally Acceptable",
      3 => "Good",
      4 => "Outstanding"
  }

  def index_for_course
    @course = Course.find(params[:course_id])
    if (current_person.is_admin? || @course.faculty.include?(current_person))
      @presentations = Presentation.find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  # GET /presentations/new
  def new
    @course = Course.find(params[:course_id])
    if (current_person.is_admin? || @course.faculty.include?(current_person))
      @presentation = Presentation.new
      @course =Course.find_by_id(params[:course_id])
    else
       has_permissions_or_redirect(:admin, root_path)
    end
  end

  # POST /presentations
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


  def new_feedback

    # Check existance of requested presentation

    @feedback = PresentationFeedback.new
    @feedback.presentation_id = params[:presentation_id]
    @questions = PresentationQuestion.existing_questions
    @eval_options = @@eval_options

    # Check whether this user has already created a feedback

    respond_to do |format|
      format.html
    end

  end

  def create_feedback

    # Check existance of requested presentation

    @feedback = PresentationFeedback.new(params[:feedback])
    @feedback.evaluator = current_person

    # Necessary checkings here

    respond_to do |format|

      is_successful = true

      params[:evaluation].each do |key, value|
        answer = PresentationFeedbackAnswer.new(value)
        begin
          question = PresentationQuestion.find(key)
        rescue ActiveRecord::RecordNotFound => e
          is_successful = false
          break
        end
        @feedback.answers << answer
        answer.question = question
      end

      if is_successful && @feedback.save
        format.html { redirect_to(@feedback) }
      else
        format.html { render :action => "new_feedback" }
      end
    end

  end

  def view_feedback
    @feedback = PresentationFeedback.find(params[:id])

    # Check abnormal routine here

    respond_to do |format|
      format.html
    end
  end

end
