require 'spec_helper'

describe 'pages/_editable_form.html.erb' do
  before do

    login(Factory(:faculty_frank))
    assign(:page, Factory.build(:page))
    assign(:courses, [
      stub_model(Course),
      stub_model(Course)
    ])
    view.should_receive(:button_name).any_number_of_times.and_return("Update")
    render
  end

  it 'should have title fields' do
      rendered.should have_selector('form') do |f|
      f.should have_selector("input[name='page[title]']")
      f.should have_selector("textarea[name='page[tab_one_contents]']")
    end
  end
end