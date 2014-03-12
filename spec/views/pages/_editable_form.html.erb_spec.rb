require 'spec_helper'

describe 'pages/_editable_form.html.erb' do
  before do

    login(FactoryGirl.create(:faculty_frank))
    assign(:page, FactoryGirl.build(:page))
    assign(:courses, [
      stub_model(Course),
      stub_model(Course)
    ])
    view.should_receive(:button_name).at_least(1).times.and_return("Update")
    view.should_receive(:enable_auto_save).at_least(1).times.and_return(false)
    view.should_receive(:enable_timeout).at_least(1).times.and_return(false)
    render
  end

  it 'should have title fields' do
      rendered.should have_selector('form') do |f|
      f.should have_selector("input[name='page[title]']")
      f.should have_selector("textarea[name='page[tab_one_contents]']")
    end
  end
end
