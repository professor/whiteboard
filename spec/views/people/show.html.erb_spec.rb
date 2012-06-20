require 'spec_helper'

describe "people/show.html.erb" do
  before(:each) do
    person = FactoryGirl(:student_sam)
    login(person)
    assign(:person, person)
  end

  it "renders attributes in <p>" do
    render
  end
end
