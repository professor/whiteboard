require 'spec_helper'

describe "courses/index.html.erb" do
  before(:each) do
    login(FactoryGirl.create(:student_sam))
    assign(:courses, [
      stub_model(Course,:name => "course1"),
      stub_model(Course,:name => "course2")
    ])
    assign(:semester_length_courses, [
      stub_model(Course,:name => "semester1"),
      stub_model(Course,:name => "semester2")
    ])
    assign(:mini_a_courses, [
      stub_model(Course,:name => "mini_a_1"),
      stub_model(Course,:name => "mini_a_2")
    ])
    assign(:mini_b_courses, [
      stub_model(Course,:name => "mini_b_1"),
      stub_model(Course,:name => "mini_b_2")
    ])
    assign(:all_courses, true)
  end

  context "renders a list of courses" do
    it "in a div" do
      render
      rendered.should have_selector("#courses_for_a_semester")
    end

    it "contains a list of all courses for this semester" do
      render
      rendered.should have_content("course1")
      rendered.should have_content("course2")
    end
  end

  context "renders a visual representation of courses" do

    it "in a div" do
      render
      rendered.should have_selector("#courses_by_length")
    end

    it "contains a list of semester courses" do
      render
      rendered.should have_content("semester1")
      rendered.should have_content("semester2")
    end

    it "contains a list of mini a courses" do
      render
      rendered.should have_content("mini_a_1")
      rendered.should have_content("mini_a_2")
    end

    it "contains a list of mini b courses" do
      render
      rendered.should have_content("mini_b_1")
      rendered.should have_content("mini_b_2")
    end

  end

end
