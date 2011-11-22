require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PresentationFeedbacksController do

  before do
      @admin_andy = Factory(:admin_andy)
      @faculty_frank = Factory(:faculty_frank)
      @faculty_fagan = Factory(:faculty_fagan)
      @student_sam = Factory(:student_sam)
      @student_sally = Factory(:student_sally)
      @presentation = Factory(:presentation, :user_id => @student_sally.id,   :creator_id => @faculty_frank.id)
    end

  # This should return the minimal set of attributes required to create a valid
  # PresentationFeedback. As you add validations to PresentationFeedback, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:content_comment => 'aaa'}
  end

  describe "GET index" do
    it "should be redirected to presentations/index_for_feedback" do
      login(@faculty_frank)
      get :index
      response.should redirect_to '/presentations/index_for_feedback'
    end
  end

  describe "GET show" do
    it "assigns the requested presentation_feedback as @presentation_feedback" do
      login(@faculty_frank)

      presentation_feedback = PresentationFeedback.new
      presentation_feedback.user_id = @faculty_frank.id
      presentation_feedback.presentation_id = @presentation.id
      presentation_feedback.content_comment = 'aaa'
      presentation_feedback.save.should == true

      get :show, :id => presentation_feedback.id.to_s
      #response.should have_content('aaa')

      assigns(:presentation_feedback).should eq(presentation_feedback)
    end
  end

  describe "GET new" do
    it "assigns a new presentation_feedback as @presentation_feedback with defined presentation_id" do
      login(@faculty_frank)

      pf = PresentationFeedback.new
      pf.presentation_id = @presentation.id

      get :new, :id => @presentation.id
      assigns(:presentation_feedback).presentation_id.should eq(pf.presentation_id)
    end
  end

  describe "GET edit" do
    it "assigns the requested presentation_feedback as @presentation_feedback" do
      login(@faculty_frank)

      presentation_feedback = PresentationFeedback.create! valid_attributes
      get :edit, :id => presentation_feedback.id.to_s
      assigns(:presentation_feedback).should eq(presentation_feedback)
    end
  end

  describe "POST create" do
    before do
      login(@faculty_frank)
    end

    describe "with valid params" do
      it "creates a new PresentationFeedback" do
        expect {
          post :create, :presentation_feedback => valid_attributes
        }.to change(PresentationFeedback, :count).by(1)
      end

      it "assigns a newly created presentation_feedback as @presentation_feedback" do
        post :create, :presentation_feedback => valid_attributes
        assigns(:presentation_feedback).should be_a(PresentationFeedback)
        assigns(:presentation_feedback).should be_persisted
      end

      it "redirects to the created presentation_feedback" do
        post :create, :presentation_feedback => valid_attributes
        response.should redirect_to(PresentationFeedback.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved presentation_feedback as @presentation_feedback" do
        # Trigger the behavior that occurs when invalid params are submitted
        PresentationFeedback.any_instance.stub(:save).and_return(false)
        post :create, :presentation_feedback => {}
        assigns(:presentation_feedback).should be_a_new(PresentationFeedback)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        PresentationFeedback.any_instance.stub(:save).and_return(false)
        post :create, :presentation_feedback => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      login(@faculty_frank)
    end

    describe "with valid params" do
      it "updates the requested presentation_feedback" do
        presentation_feedback = PresentationFeedback.create! valid_attributes
        # Assuming there are no other presentation_feedbacks in the database, this
        # specifies that the PresentationFeedback created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PresentationFeedback.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => presentation_feedback.id, :presentation_feedback => {'these' => 'params'}
      end

      it "assigns the requested presentation_feedback as @presentation_feedback" do
        presentation_feedback = PresentationFeedback.create! valid_attributes
        put :update, :id => presentation_feedback.id, :presentation_feedback => valid_attributes
        assigns(:presentation_feedback).should eq(presentation_feedback)
      end

      it "redirects to the presentation_feedback" do
        presentation_feedback = PresentationFeedback.create! valid_attributes
        put :update, :id => presentation_feedback.id, :presentation_feedback => valid_attributes
        response.should redirect_to(presentation_feedback)
      end
    end

    describe "with invalid params" do
      it "assigns the presentation_feedback as @presentation_feedback" do
        presentation_feedback = PresentationFeedback.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PresentationFeedback.any_instance.stub(:save).and_return(false)
        put :update, :id => presentation_feedback.id.to_s, :presentation_feedback => {}
        assigns(:presentation_feedback).should eq(presentation_feedback)
      end

      it "re-renders the 'edit' template" do
        presentation_feedback = PresentationFeedback.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PresentationFeedback.any_instance.stub(:save).and_return(false)
        put :update, :id => presentation_feedback.id.to_s, :presentation_feedback => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before do
      login(@faculty_frank)
    end

    it "destroys the requested presentation_feedback" do
      presentation_feedback = PresentationFeedback.create! valid_attributes
      expect {
        delete :destroy, :id => presentation_feedback.id.to_s
      }.to change(PresentationFeedback, :count).by(-1)
    end

    it "redirects to the presentation_feedbacks list" do
      presentation_feedback = PresentationFeedback.create! valid_attributes
      delete :destroy, :id => presentation_feedback.id.to_s
      response.should redirect_to(presentation_feedbacks_url)
    end
  end

end
