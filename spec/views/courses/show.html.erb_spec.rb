require 'spec_helper'

describe "courses/show.html.erb" do
  before(:each) do
    current_user = FactoryGirl(:student_sam)
    login(current_user)
    assign(:course, FactoryGirl(:course))
  end

  it "renders attributes in <p>" do
    render
  end
end
