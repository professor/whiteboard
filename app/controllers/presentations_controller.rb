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
      p @presentations
    else
      has_permissions_or_redirect(:admin, root_path)
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

    params[:evaluation].each do |key, value|
      answer = PresentationFeedbackAnswer.new(value)
      @feedback.answers << answer
      answer.question_id = key
    end

    # Necessary checkings here

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to(@feedback) }
      else
        format.html { render :action => "new" }
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
