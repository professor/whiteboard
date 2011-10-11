require 'spec_helper'

describe "courses/index.html.erb" do
  before(:each) do
    assign(:courses, [
      stub_model(Course,:name => "something"),
      stub_model(Course,:name => "something2")
    ])
    assign(:all_courses, true)
    current_user = Factory.build(:student_sam)
  end

  it "renders a list of courses" do
    render
  end
end
