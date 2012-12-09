require 'spec_helper'

describe "people/index.html.erb" do

  before(:each) do
    login(FactoryGirl.create(:student_sam))
    render
  end

  it "should have search text input fields" do
    rendered.should have_selector("#smart_search_text")
    rendered.should have_selector("#search_text_box")
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
    rendered.should have_selector("input[type='checkbox']", :content => 'Exact Match?')
    rendered.should have_selector("input[type='checkbox']", :content => 'Include Inactive Users?')
    rendered.should have_content("Customize")
    rendered.should have_content("Export Results")
  end
end
