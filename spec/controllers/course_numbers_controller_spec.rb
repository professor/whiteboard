require 'spec_helper'

describe CourseNumbersController do

  let(:course) { Factory(:course) }

  context "any user can" do
    before do
      login_user(Factory(:student_sam))
      #login_user(:student_sam)
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:courses).should_not be_nil }
    end

  end

end