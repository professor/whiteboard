require 'spec_helper'

describe "courses/index.html.erb" do
  before(:each) do
    login(FactoryGirl(:student_sam))
    assign(:courses, [
      stub_model(Course,:name => "something"),
      stub_model(Course,:name => "something2")
    ])
    assign(:all_courses, true)
  end

  it "renders a list of courses" do
    render
  end
end
