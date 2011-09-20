require 'spec_helper'

describe SystemController do


  context "any user" do
    before do
      login(Factory(:student_sam))
    end

    describe "GET index" do
      before do
        get :index
      end

      it "should only setup normal rails information" do
#        response.status.should be(200)
      end

    end

  end
end