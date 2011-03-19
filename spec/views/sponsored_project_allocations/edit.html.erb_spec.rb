#require 'spec_helper'
#
#describe "sponsored_project_allocations/edit.html.erb" do
#  before(:each) do
#    @allocation = assigns[:allocation] = stub_model(SponsoredProjectAllocation, :new_record? => false)
#    assigns[:projects] = [Factory.build(:sponsored_project)]
#    assigns[:people] = [Factory.build(:faculty_frank), Factory.build(:admin_andy)]
#  end
#
#  it "renders edit allocation form" do
#    render
#
#    response.should have_tag("form", :action => sponsored_project_allocations_path(@allocation), :method => "post")
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
