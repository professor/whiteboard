require 'spec_helper'
require 'controllers/permission_behavior'

describe PresentationsController do

    before do
      @admin_andy = Factory(:admin_andy)
      @faculty_frank = Factory(:faculty_frank)
      @faculty_fagan = Factory(:faculty_fagan)
      @student_sam = Factory(:student_sam)
      @student_sally = Factory(:student_sally)
    end

    describe "GET my_presentations" do
      before(:each) do
        @presentation = Factory(:presentation, :user_id => @student_sam.id, :creator_id => @faculty_frank.id)
      end

      context "as the user assigned to the presentation" do
        before do
          login(@student_sam)
        end

        it 'assigns presentations' do
          get :my_presentations, :id => @student_sam.id
          assigns(:presentations).should == [@presentation]
        end
      end

      context "as a faculty" do

        before do
          login(@faculty_frank)
        end

        it 'assigns created presentations to @presentations' do
          get :my_presentations, :id => @faculty_frank.id
          assigns(:created_presentations).should == [@presentation]
          assigns(:presentations).should == []
        end

        it 'assigns @deliverables' do
          get :my_presentations, :id => @student_sam.id
          assigns(:presentations).should == [@presentation]
        end
      end

      context "as any other student" do
        before do
          login(@student_sally)
          get :my_presentations, :id => @student_sam.id
        end

        it_should_behave_like "permission denied for person presentation"
      end
    end

    describe "GET show" do
      before(:each) do
        @presentation = Factory(:presentation, :user_id => @student_sam.id, :creator_id => @faculty_frank.id)
      end

      it 'any user can see it' do
          login(@student_sally)
          get :show, :id => @presentation.id
          assigns(:presentation).should == @presentation
      end
    end

    describe "GET edit" do
      before(:each) do
        @presentation = Factory(:presentation, :user_id => @student_sam.id, :creator_id => @faculty_frank.id)
      end

      context "as the creator" do
        it "should assign the presentation" do
          login(@faculty_frank)
          get :edit, :id => @presentation.id
          assigns(:presentation).should == @presentation
        end
      end

      context "as any other faculty" do
        before do
          login(@faculty_fagan)
          get :edit, :id => @presentation.id
        end

        it_should_behave_like "permission denied for person presentation"
      end

      context "as an admin" do
        it "should assign the presentation" do
          login(@admin_andy)
          get :edit, :id => @presentation.id
          assigns(:presentation).should == @presentation
        end
      end

      context "as any other user" do
        before do
          login(@student_sally)
          get :edit, :id => @presentation.id
        end

        it_should_behave_like "permission denied for person presentation"
      end
    end

    describe "PUT update" do
      before(:each) do
        @presentation = Factory(:presentation, :user_id => @student_sam.id, :creator_id => @faculty_frank.id)
      end

      context "as a valid updater (admin or creator)" do
        it "updates the presentation with valid attributes" do
          login(@faculty_frank)
          put :update, :id => @presentation.id, :presentation => {:name => "This is a different name"}
          @presentation.reload.name.should == "This is a different name"
        end

        it "updates the presentation with invalid attributes" do
          login(@faculty_frank)
          put :update, :id => @presentation.id, :presentation => {:team_id => 1, :user_id => 1}
          response.should render_template("edit")
        end
      end

      context "as any other user" do
        it "should redirect to root and show error" do
          login(@faculty_fagan)
          put :update, :id => @presentation.id, :presentation => {:name => "This a different name"}
          response.should redirect_to(root_path)
        end
      end
    end

end