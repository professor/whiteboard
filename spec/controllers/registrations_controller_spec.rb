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
    describe "#index" do
      it "should respond to json" do
        login(staff)

        get :index, { :format => 'json' }
        response.should be_success
      end

      it "should respond to html" do
        login(staff)

        get:index, { :format => 'html' }
        response.should be_success
      end
    end
  end

  context "when there is a course_id" do
    it "should return 404 if course with course_id is not found"

    describe "#index" do
      it "should still succeed if there are no registrations for this course"

      it "should return empty array of registrations"

      it "should return registrations if found"
    end
  end
end
