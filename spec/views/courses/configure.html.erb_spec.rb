require 'spec_helper'

describe "courses/configure.html.erb" do
  before(:each) do
    UserSession.create(Factory(:faculty_frank))
    @course = assigns[:course] = stub_model(Course,
        :name => "something",
      :new_record? => false
    )
  end

  it "renders the configure course form" do
    render

    response.should have_tag("form", :action => course_path(@course), :method => "post")
  end
end
