require 'spec_helper'

describe CourseNumbersController do

  let(:course) { Factory(:course) }

  context "any user can" do
    before do
      sign_in(Factory(:student_sam))
      #sign_in(:student_sam)
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:courses).should_not be_nil }
    end

  end

end