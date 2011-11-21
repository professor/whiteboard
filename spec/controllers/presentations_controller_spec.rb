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

  context "Faculty can" do
    before do
      @faculty_frank = Factory(:faculty_frank)
      @course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 42)
      @presentation = stub_model(Presentation, :course_id => @course.id)
      Presentation.stub(:find_all_by_course_id).and_return([@presentation, @presentation])
      Course.stub(:find).and_return(@course)

      login(Factory(:admin_andy))
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
          :present_date =>"2011-11-21 05:00:00",
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
          :present_date =>nil,
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
       login(Factory(:student_sally))

      @faculty_frank = Factory(:faculty_frank)
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
