require 'spec_helper'

describe CourseNumbersController do

  let(:course) { FactoryGirl.create(:course) }

  context "any user can" do
    before do
      login FactoryGirl.create(:student_sam)
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:courses).should_not be_nil }
    end

  end

end