require 'spec_helper'

describe "people/edit.html.erb" do
  before(:each) do
    person = Factory(:student_sam)
    UserSession.create(person)
    @person = assigns[:person] = person
    
    assigns[:strength_themes] =  [
      stub_model(StrengthTheme),
      stub_model(StrengthTheme)
    ]
  end

  it "renders the edit page form" do
    render

    response.should have_tag("form", :action => person_path(@person), :method => "post")
  end
end
