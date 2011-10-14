require 'spec_helper'
require 'controllers/permission_behavior'

describe DelayedSystemJobsController do


  let(:delayed_system_job) { Factory(:delayed_system_job) }


  context "any user can" do
    before do
      login(Factory(:student_sam))
    end

    describe "GET index" do
      before do
        get :index
      end

      it_should_behave_like "permission denied"
    end


    describe "DELETE destroy" do
      before do
        delete :destroy, :id => delayed_system_job.to_param
      end

      it_should_behave_like "permission denied"
    end

  end

  context "any admin can" do
    before do
      login(Factory(:admin_andy))
    end

    describe "GET index" do
      before do
        get :index
      end
      
      specify { assigns(:delayed_system_jobs).should_not be_nil }

    end

      it "destroys the course" do
#       course.should_receive(:destroy)

#        lambda {
#          a = Course.count
#          c = course
#          delete :destroy, :id => course.to_param
#          b = Course.count
#          t = 1
#        }.should change(Course, :count).by(1)
      end

  end
  

end
