require 'spec_helper'

describe "courses/show.html.erb" do
  before(:each) do
    UserSession.create(Factory(:student_sam))    
    assigns[:course] = Factory(:course)
  end

  it "renders attributes in <p>" do
    render
  end
end
