require 'spec_helper'

describe CourseNavigationsController do

  let(:course) { FactoryGirl.create(:course) }

  context "any user can" do
    before do
      login(FactoryGirl.create(:student_sam))
    end

    describe "GET show" do
      before do
        get :show, :id => course.to_param
      end

      it "can't access page" do
        response.should redirect_to(root_path)
      end
    end

  end

  context "any faculty can" do
    before do
      login(FactoryGirl.create(:faculty_frank))
    end

    describe "GET show" do
      before do
        get :show, :id => course.to_param
      end

      specify { assigns(:course).should_not be_nil }
      specify { assigns(:pages).should_not be_nil }

    end

  end


#  context "any faculty can" do
#    before do
#      login(FactoryGirl.create(:faculty_frank))
#    end
#
#    describe "GET reposition" do
#
#      it ''
#
#    end
#  end

end