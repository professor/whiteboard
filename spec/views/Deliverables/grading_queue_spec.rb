require 'spec_helper'



context "shows the checkboxes for Individual, Team and Graded" do
  render
  rendered.should have_content("Show Individual")
  rendered.should have_content("Show Team")
  rendered.should have_content("Graded")

end

context "shows a tabular display of deliverables" do
    render :partial => "deliverables/deliverable_listing_professor.html.erb",
           :locals => {:style => nil, :state => "length" }
    rendered.should have_content("Name")
    rendered.should have_content("Task")
    rendered.should have_content("Content")
    rendered.should have_content("Grade")

end