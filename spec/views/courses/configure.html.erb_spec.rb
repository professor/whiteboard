require 'spec_helper'

describe "courses/configure.html.erb" do
  before(:each) do
    current_user = Factory.build(:faculty_frank)
    @course = assign(:course, stub_model(Course,
        :name => "something",
        :semester => "Fall",
        :year => "2011",
        :mini => "Both",
      :new_record? => false
    ))
  end

  it "renders the configure course form" do
    render

    rendered.should have_selector("form", :action => course_path(@course), :method => "post")
  end
end
