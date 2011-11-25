require 'spec_helper'

describe RegistrationsController do
  let(:student) { Factory.create(:student_sally) }
  let(:staff) { Factory.create(:faculty_frank) }
  let(:course) { Factory.build(:course) }
  let(:registration) { Factory.build(:registration, :course => course, :person => student) }

  context "when not authenticated" do
    it "should be redirected to authorize path" do
      get :index
      response.should redirect_to(controller.user_omniauth_authorize_path(:google_apps, :origin => request.fullpath))
    end
  end

  context "when authenticated but lacking rights" do
    it "should return 401 Unauthorized" do
      login(student)

      get :index
      response.code.should == "401"
    end
  end

  context "when authenticated with proper rights" do
    it "should return 200 success" do
      login(staff)

      get :index
      response.should be_success
    end
  end

  context "when a course_id is not provided" do
    before(:each) do
      login(staff)
    end

    describe "#index" do
      it "should respond to json" do
        get :index, { :format => 'json' }
        response.should be_success
      end

      it "should respond to html" do
        get :index, { :format => 'html' }
        response.should be_success
      end
    end
  end

  context "when course_id is provided" do
    before(:each) do
      login(staff)
    end
    it "should return 404 if not in DB" do
      get :index, { :format => 'json', :course_id => 0 }
      response.code.should == '404'
    end

    describe "#index" do
      it "should succeed with 0 registrations" do
        Registration.stub!(:scoped_by_params).once.with(hash_including(:course_id => 1)).and_return([])

        get :index, { :course_id => 1 }
        response.should be_success
      end

      it "should return empty array of registrations" do
        Registration.stub!(:scoped_by_params).once.with(hash_including(:course_id => 1)).and_return([])

        get :index, { :format => 'json', :course_id => 1 }
        assigns(:registrations).should be_empty
      end

      it "should return registrations if found" do
        Registration.stub!(:scoped_by_params).once.with(hash_including(:course_id => 1)).and_return([registration])

        get :index, { :format => 'json', :course_id => 1 }
        assigns(:registrations).should == [registration]
      end
    end
  end

  describe "#bulk_import" do
    before(:each) do
      login(staff)
    end

    it "should be success" do
      get :bulk_import
      
      response.should be_success
    end
  end
end
