require 'spec_helper'

describe ProjectsController do

  context "as a non admin" do
    before do
      student = Factory(:student_sam)
      login(student)
    end

    describe "#destroy" do
      it "redirects to the projects_url" do
        project = Project.create!
        delete :destroy, :id => project.to_param
        response.should redirect_to projects_url
      end
    end

  end

end