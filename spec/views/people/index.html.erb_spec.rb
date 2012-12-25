require 'spec_helper'

describe 'people/index.html.erb' do
  before(:each) do
    person = FactoryGirl.create(:student_sam)
    login(person)
    @person = assign(:person, person)
    @people = [FactoryGirl.build(:student_sally, :id => 1), FactoryGirl.build(:faculty_frank, :id => 2)] 
  end

  it "renders the index page" do
    render
  end

  it "should have first name, last name, contact details and the program" do
    render
    rendered.should have_content("First name")
    rendered.should have_content("Last name")
    rendered.should have_content("Contact Details")
    rendered.should have_content("Program")
  end

end