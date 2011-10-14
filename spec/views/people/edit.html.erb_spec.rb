require 'spec_helper'

describe "people/edit.html.erb" do
  before(:each) do
    person = Factory(:student_sam)
    login(person)
    @person = assign(:person, person)
    
    assign(:strength_themes, [
      stub_model(StrengthTheme),
      stub_model(StrengthTheme)
    ])
  end

  it "renders the edit page form" do
    render

    rendered.should have_selector("form", :action => person_path(@person), :method => "post")
  end
end
