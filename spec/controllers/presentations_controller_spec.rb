require 'spec_helper'

describe PresentationsController do
  context "any user can" do
    before do
      login(Factory(:student_sam))
      @presentation = Factory(:presentation)
    end

    describe "GET new_feedback" do
      it "should redirect to presentation view if it does not exist" do

      end

      it "should pass its view a new feedback" do
        get :new_feedback, :presentation_id => @presentation.id
        feedback = assigns :feedback

        feedback.presentation_id.should == @presentation.id
      end

      it "should pass its view a list of questions" do
        get :new_feedback, :presentation_id => @presentation.id
        questions = assigns :questions

        questions.length.should == PresentationFeedback.count
        questions.each do |q|
          q.text.should == PresentationFeedback.find(q.id).text
        end
      end
    end

    describe "POST create_feedback" do

      before do
        @q1 = Factory(:presentation_feedback_questions, :text => "q1")
        @q2 = Factory(:presentation_feedback_questions, :text => "q2")
        @q3 = Factory(:presentation_feedback_questions, :text => "q3")
        @q4 = Factory(:presentation_feedback_questions, :text => "q4")
      end

      it "record the returned feedback" do
        feedback = {
          "presentation_id" => @presentation.id
        }
        evaluation = {
          @q1.id => {"rating" => 1, "comment" => "comment 1"},
          @q2.id => {"rating" => 2, "comment" => "comment 2"},
          @q3.id => {"rating" => 3, "comment" => "comment 3"},
          @q4.id => {"rating" => 4, "comment" => "comment 4"}
        }

        start_date = DateTime.now
        post :create_feedback, {:feedback => feedback, :evaluation => evaluation}

        feedback = PresentationFeedback.where("created_at >= ?", start_date)
        feedback.length.should == 1
        feedback = feedback[0]
        feedback.presentation_id.should == @presentation.id
        response.should redirect_to(:action => "view_feedback", :id => feedback.id)

        answers = PresentationFeedbackAnswer.where("created_at >= ?", start_date)
        answers.length.should == 4

        answers.each do |a|
          a.feedback.should == feedback
        end
      end

      it "should redirect to new feedback page if an evaluation has an invalid ID" do
        feedback = {
            "presentation_id" => @presentation.id
        }
        evaluation = {
            1000 => {"rating" => 1, "comment" => "comment 1"}
        }

        post :create_feedback, {:feedback => feedback, :evaluation => evaluation}

        response.should render_template('new_feedback')
      end

    end
  end

end
