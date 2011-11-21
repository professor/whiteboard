require 'spec_helper'

describe PresentationsController do
  context "any user can" do
    before do
      login(Factory(:student_sam))
      @presentation = Factory(:presentation)
    end

    describe "GET new_feedback" do
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
      it "record the returned feedback" do
        feedback = {
          "presentation_id" => @presentation.id
        }
        evaluation = {
          1 => {"rating" => 1, "comment" => "comment 1"},
          2 => {"rating" => 2, "comment" => "comment 2"},
          3 => {"rating" => 3, "comment" => "comment 3"},
          4 => {"rating" => 4, "comment" => "comment 4"}
        }

        start_date = DateTime.now
        post :create_feedback, {:feedback => feedback, :evaluation => evaluation}

        response.should be_redirect

        feedback = PresentationFeedback.where("created_at >= ?", start_date)
        feedback.length.should == 1
        feedback = feedback[0]
        feedback.presentation_id.should == @presentation.id

        answers = PresentationFeedbackAnswer.where("created_at >= ?", start_date)
        answers.length.should == 4

        answers.each do |a|
          a.feedback.should == feedback
        end
      end
    end
  end

end
