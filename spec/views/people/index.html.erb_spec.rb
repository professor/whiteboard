require 'spec_helper'

describe "people/index.html.erb" do

  before(:each) do
    login(FactoryGirl.create(:student_sam))
    render
  end

  it "should have search text input field" do

    rendered.should have_selector("#search_text_box")
  end

  it "should have main search criteria" do

    rendered.should have_selector("#criteria_first_name", :content => 'First Name')
    rendered.should have_selector("#criteria_last_name", :content => 'Last Name')
    rendered.should have_selector("#criteria_andrew_id", :content => 'Andrew ID')

  end

  it "should have people type and extra criteria drop down menus" do
    # People Type Testing
    rendered.should have_selector("#people_type_picker option[value='all']")
    rendered.should have_selector("#people_type_picker option[value='student']")
    rendered.should have_selector("#people_type_picker option[value='staff']")
    rendered.should have_selector("#people_type_picker option[value='alumnus']")

    #Extra Criteria Testing
    rendered.should have_selector("#extra_criteria_picker option[value='company']")
    rendered.should have_selector("#extra_criteria_picker option[value='class_year']")
    rendered.should have_selector("#extra_criteria_picker option[value='program']")
    rendered.should have_selector("#extra_criteria_picker option[value='ft_pt']")

  end

  it "should have Go button, exact match, customization, exports results" do
    rendered.should have_selector("button", :content => 'Go')
    rendered.should have_selector("input[type='checkbox']", :content => 'Exact Match?')
    rendered.should have_link("Customization")
    rendered.should have_link("Export Results")
  end
end
