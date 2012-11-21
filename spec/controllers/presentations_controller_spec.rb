require 'spec_helper'

describe PresentationsController do
  context "any user can" do
    before do
      @student_sam = FactoryGirl.create(:student_sam)
      login(@student_sam)
      @presentation = FactoryGirl.create(:presentation)
    end

    describe "GET new_feedback" do
      it "should redirect to presentation view if it does not exist" do

      end

      it "should pass its view a new feedback" do
        get :new_feedback, :id => @presentation.id
        feedback = assigns :feedback

        feedback.presentation_id.should == @presentation.id
      end

      it "should pass its view a list of questions" do
        get :new_feedback, :id => @presentation.id
        questions = assigns :questions

        questions.length.should == PresentationFeedback.count
        questions.each do |q|
          q.text.should == PresentationFeedback.find(q.id).text
        end
      end
    end

    describe "POST create_feedback" do

      before do
        @q1 = FactoryGirl.create(:presentation_feedback_questions, :text => "q1")
        @q2 = FactoryGirl.create(:presentation_feedback_questions, :text => "q2")
        @q3 = FactoryGirl.create(:presentation_feedback_questions, :text => "q3")
        @q4 = FactoryGirl.create(:presentation_feedback_questions, :text => "q4")
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
        post :create_feedback, {:feedback => feedback, :evaluation => evaluation, :id => @presentation.id}

        feedback = PresentationFeedback.where("created_at >= ?", start_date)
        feedback.length.should == 1
        feedback = feedback[0]
        feedback.presentation_id.should == @presentation.id
        response.should redirect_to(today_presentations_url)

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

        post :create_feedback, {:feedback => feedback, :evaluation => evaluation, :id => @presentation.id}

        response.should render_template('new_feedback')
      end

    end

    describe "GET edit_feedback" do
      before do
        @q1 = FactoryGirl.create(:presentation_feedback_questions, :text => "q1")
        @q2 = FactoryGirl.create(:presentation_feedback_questions, :text => "q2")
        @q3 = FactoryGirl.create(:presentation_feedback_questions, :text => "q3")
        @q4 = FactoryGirl.create(:presentation_feedback_questions, :text => "q4")
      end

      it "that they have given" do
        student_sally = FactoryGirl.create(:student_sally)
        login(student_sally)
        local_feedback = {
          "presentation_id" => @presentation.id
        }
        evaluation = {
          @q1.id => {"rating" => 1, "comment" => "comment 1"},
          @q2.id => {"rating" => 2, "comment" => "comment 2"},
          @q3.id => {"rating" => 3, "comment" => "comment 3"},
          @q4.id => {"rating" => 4, "comment" => "comment 4"}
        }

        start_date = DateTime.now
        post :create_feedback, {:feedback => local_feedback, :evaluation => evaluation, :id => @presentation.id}
        response.should redirect_to(today_presentations_url)
        
        get :edit_feedback, {:id => @presentation.id}
        # response.should redirect_to(edit_feedback_for_presentation_path)
        feedback = assigns :feedback
        ratings = assigns :ratings
        comments = assigns :comments

        feedback.evaluator_id.should == student_sally.id 
        ratings.should include(1,2,3,4)
        comments.should include("comment 1", "comment 2", "comment 3", "comment 4")


      end
    end

    describe "PUT edit_feedback" do
      before do
        @q1 = FactoryGirl.create(:presentation_feedback_questions, :text => "q1")
        @q2 = FactoryGirl.create(:presentation_feedback_questions, :text => "q2")
        @q3 = FactoryGirl.create(:presentation_feedback_questions, :text => "q3")
        @q4 = FactoryGirl.create(:presentation_feedback_questions, :text => "q4")
      end

      it "that they have given" do
        student_sally = FactoryGirl.create(:student_sally)
        login(student_sally)
        local_feedback = {
          "presentation_id" => @presentation.id
        }
        evaluation = {
          @q1.id => {"rating" => 1, "comment" => "comment 1"},
          @q2.id => {"rating" => 2, "comment" => "comment 2"},
          @q3.id => {"rating" => 3, "comment" => "comment 3"},
          @q4.id => {"rating" => 4, "comment" => "comment 4"}
        }

        start_date = DateTime.now
        post :create_feedback, {:feedback => local_feedback, :evaluation => evaluation, :id => @presentation.id}
        response.should redirect_to(today_presentations_url)
        
        get :edit_feedback, {:id => @presentation.id}
        # response.should redirect_to(edit_feedback_for_presentation_path)
        feedback = assigns :feedback
        ratings = assigns :ratings
        comments = assigns :comments

        feedback.evaluator_id.should == student_sally.id 
        ratings.should include(1,2,3,4)
        comments.should include("comment 1", "comment 2", "comment 3", "comment 4")

        edited_evaluation = {
          @q1.id => {"rating" => 4, "comment" => "comment 1 edited"},
          @q2.id => {"rating" => 3, "comment" => "comment 2 edited"},
          @q3.id => {"rating" => 2, "comment" => "comment 3 edited"},
          @q4.id => {"rating" => 1, "comment" => "comment 4 edited"}
        }
        post :edit_feedback, {:id => @presentation.id, :evaluation => edited_evaluation }

        new_feedback = PresentationFeedback.where("created_at >= ?", start_date)
        new_feedback.length.should == 1
        new_feedback = new_feedback[0]
        new_feedback.presentation_id.should == @presentation.id
        answers = PresentationFeedbackAnswer.where("created_at >= ?", start_date)
        answers.length.should == 4

        answers.each do |a|
          a.feedback.should == new_feedback
        end
      end
    end

  end

  context "Faculty can" do
    before do
      @faculty_frank = FactoryGirl.create(:faculty_frank)
      @course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 42)
      @presentation = stub_model(Presentation, :course_id => @course.id)
      Presentation.stub(:find_all_by_course_id).and_return([@presentation, @presentation])
      Course.stub(:find).and_return(@course)

      login(FactoryGirl.create(:admin_andy))
    end

    describe "GET index_for_course" do
        it 'should be success' do
          get :index_for_course, :course_id => @course.id
          response.should_not be_redirect
        end

        it 'assign presentations' do
          get :index_for_course, :course_id => @course.id
          assigns(:presentations).should == [@presentation,@presentation]
        end
    end

    describe "get new" do
        it 'should be success' do
          get :new, :course_id => @course.id
          response.should_not be_redirect
        end
     end

     describe "post new" do
        it 'should be success' do
        presentation = {
          :name => "test_pre",
          :team_id => 1,
          :presentation_date =>"2011-11-21 05:00:00",
          :task_number => 1,
          :owner => "jj"
        }
          post :create, {:course_id => @course.id, :presentation => presentation}

          Presentation.find_by_name("test_pre").task_number.should == "1"
        end

        it 'should not be success' do
        presentation = {
          :name => nil,
          :team_id => 1,
          :presentation_date =>nil,
          :task_number => 1,
          :owner => "jj"
        }
          post :create, {:course_id => @course.id, :presentation => presentation}

          Presentation.find_by_name("test_pre").should be_nil
        end
     end


  end


  context "Student Can NOT" do
     before do
       login(FactoryGirl.create(:student_sally))

      @faculty_frank = FactoryGirl.create(:faculty_frank)
      @course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 42)
      @presentation = stub_model(Presentation, :course_id => @course.id)
      Course.stub(:find).and_return(@course)
     end

     describe "GET index_for_course" do
       it "should be success" do
         get :index_for_course, :course_id => @course.id
         response.should redirect_to(root_path)
       end
     end

     describe "get new" do
        it 'should not be success' do
          get :new, :course_id => @course.id
         response.should redirect_to(root_path)
        end
     end

  end
end
