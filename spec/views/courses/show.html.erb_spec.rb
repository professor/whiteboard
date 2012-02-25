require 'spec_helper'

describe "courses/show.html.erb" do
  before(:each) do
    current_user = Factory(:student_sam)
    login(current_user)
    assign(:course, Factory(:course))
  end

  it "renders attributes in <p>" do
    render
  end
end
