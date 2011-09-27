require 'spec_helper'

describe "courses/show.html.erb" do
  before(:each) do
    current_user = Factory.build(:student_sam)
    assign(:course, Factory(:course))
  end

  it "renders attributes in <p>" do
    render
  end
end
