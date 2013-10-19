require 'spec_helper'


describe "grading_queue_for_course" do

  before do
    # add_faculty

    # add courses
    # add deliverables
  end

  describe "GET /deliverables" do
    before do
      visit ('/deliverables')
      # login as faculty
      # go to courses
      # select a course
      # go to grading assignment
    end

    context "display the filters and headers"
    it "shows the checkboxes for Individual, Team and Graded" do
      page.should have_content("Show Individual")
      page.should have_content("Show Team")
      page.should have_content("Graded")
    end

    it "shows a tabular display of deliverables" do
      render :partial => "deliverables/deliverable_listing_professor.html.erb"
      #:locals => {:style => nil, :state => "length" }
      page.should have_content("Name")
      page.should have_content("Task")
      page.should have_content("Content")
      page.should have_content("Grade")
    end

  end
end