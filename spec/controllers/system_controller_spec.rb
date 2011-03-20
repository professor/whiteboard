require 'spec_helper'

describe SystemController do


  context "any user" do
    before do
      UserSession.create(Factory(:student_sam))
    end

    describe "GET index" do

      it "should only setup normal rails information" do
        
      end

    end

  end
end