#require 'spec_helper'
#
#describe "sponsored_project_efforts/edit.html.erb" do
#  before(:each) do
#    @efforts = assigns[:efforts] = [Factory(:sponsored_project_effort)]
#
##    @effort = assigns[:effort] = stub_model(SponsoredProjectEffort, :new_record? => false)
#  end
#
#  it "renders edit effort form" do
#    render
#
#    response.should have_tag("form", :action => sponsored_project_efforts_path(@efforts), :method => "post")
#
#  end
#
#  it "renders a list of sponsors to pick from" do
#    #Todo , make this test more interesting in rails 3
#    render
#
#    response.should have_tag("select")
#  end
#end
