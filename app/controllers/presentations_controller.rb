class PresentationsController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  @@eval_options = {
      1 => "Poor",
      2 => "Minimally Acceptable",
      3 => "Good",
      4 => "Outstanding"
  }

  # GET /courses/:course_id/presentations
  def index_for_course
    @course = Course.find(params[:course_id])
    if (current_person.is_admin? || @course.faculty.include?(current_person))
      @presentations = Presentation.find_all_by_course_id(@course.id)
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end

  # GET /course/:person_id/presentations/new
  def new
    @course = Course.find(params[:course_id])
    if (current_person.is_admin? || @course.faculty.include?(current_person))
      @presentation = Presentation.new
      @course =Course.find_by_id(params[:course_id])
    else
       has_permissions_or_redirect(:admin, root_path)
    end
  end

  # POST /course/:person_id/presentations
  def create
	  @course = Course.find(params[:course_id])
    if params[:presentation][:person].blank?
      person_id = nil
    else
      @person = Person.find_by_human_name(params[:presentation][:person])
      person_id = @person.id
    end


    @presentation= Presentation.new(:person_id=>person_id,
                                    :name=>params[:presentation][:name],
                                    :team_id=>params[:presentation][:team_id],
                                    :presentation_date=>params[:presentation][:presentation_date],
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

    # Check existence of requested presentation

    @feedback = PresentationFeedback.new
    @feedback.presentation_id = params[:presentation_id]
    @questions = PresentationQuestion.existing_questions
    @eval_options = @@eval_options
	  @presentation  = Presentation.find(params[:presentation_id])

  	if @presentation.team_id.nil?
	    @presenter = @presentation.person.human_name
	  else
	    @presenter = @presentation.team.name
	  end

    # Check whether this user has already created a feedback

    respond_to do |format|
      format.html
    end

  end

  def create_feedback

    # Check existence of requested presentation

    @feedback = PresentationFeedback.new(params[:feedback])
    @feedback.evaluator = current_person
	  @presentation = Presentation.find(params[:presentation_id])
	  @feedback.presentation = @presentation

	  if @presentation.feedbacks.empty?
	    @presentation.feedback_email_sent = false
  	else
	    @presentation.feedback_email_sent = true
	  end
	  @presentation.save


    # Necessary checks here

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
		if !@presentation.feedback_email_sent?
			@presentation.send_presentation_feedback_email( presentation_feedback_url(:id=> params[:presentation_id]))
		end
        format.html { redirect_to(root_path) }
      else
        format.html { render :action => "new_feedback" }
      end
    end

  end

  def show_feedback
	 @presentation = Presentation.find(params[:id])
	 @feedbacks = PresentationFeedback.find(:all,  :conditions => {:presentation_id => params[:id]})

	 if @presentation.team_id.nil?
	    @presenter = @presentation.person.human_name
	 else
	    @presenter = @presentation.team.name
	 end

	 @faculty_feedbacks = []
	 @student_feedbacks = []

	 @questions= PresentationQuestion.find(:all, :conditions => {:is_deleted => false})

	 @feedbacks.each do |f|
	   evaluator = User.find(f.evaluator_id)
	   if evaluator.is_teacher? || evaluator.is_staff?
			 @faculty_feedbacks << f
	   elsif evaluator.is_student?
			 @student_feedbacks << f
	   end
	 end

	 @faculty_ratings = Presentation.find_ratings(@faculty_feedbacks, @questions)
	 @student_ratings = Presentation.find_ratings(@student_feedbacks, @questions)

	 @faculty_comments = Presentation.find_comments(@faculty_feedbacks, @questions)
	 @student_comments = Presentation.find_comments(@student_feedbacks, @questions)

	 respond_to do |format|
	 	  format.html
	 end
  end

end
