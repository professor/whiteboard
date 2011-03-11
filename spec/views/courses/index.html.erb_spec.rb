require 'spec_helper'

describe "courses/index.html.erb" do
  before(:each) do
    assigns[:courses] = [
      stub_model(Course,:name => "something"),
      stub_model(Course,:name => "something2")
    ]
    assigns[:all_courses] = true
  end

  it "renders a list of courses" do
    render
  end
end
