require 'spec_helper'

describe "people/show.html.erb" do
  before(:each) do
    person = Factory(:student_sam)
    UserSession.create(person)
    assigns[:person] = person #rspec 1?
  end

  it "renders attributes in <p>" do
    render
  end
end
