require 'spec_helper'

describe "sponsored_project_efforts/edit.html.erb" do
  before(:each) do
    @faculty_frank = Factory(:faculty_frank)
    @efforts = assigns[:efforts] = [Factory(:sponsored_project_effort)]
    assigns[:id] = @faculty_frank.twiki_name
#    @effort = assigns[:effort] = stub_model(SponsoredProjectEffort, :new_record? => false)
  end

  it "renders edit effort form" do
    render# :id => @faculty_frank.twiki_name

#    response.should have_tag("form", :action => sponsored_project_effort_path(@efforts[0].sponsored_project_allocation.person.twiki_name), :method => "post")

  end


end
