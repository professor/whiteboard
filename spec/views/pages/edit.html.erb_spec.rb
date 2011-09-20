require 'spec_helper'

describe "pages/edit.html.erb" do
  before(:each) do
    login(Factory(:faculty_frank))
    @page = assign(:page, stub_model(Page,
        :url => "something",
      :new_record? => false
    ))
    assign(:courses, [
      stub_model(Course),
      stub_model(Course)
    ])
  end

  it "renders the edit page form" do
    render

    rendered.should have_selector("form", :action => page_path(@page), :method => "post")
  end
end
