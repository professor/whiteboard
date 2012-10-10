require 'spec_helper'

describe "Assignments" do
  before do
    @course = FactoryGirl.create(:fse)
  end
  describe "GET /assignments" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get course_assignments_path(@course)
      response.status.should be(200)
    end
  end
end
