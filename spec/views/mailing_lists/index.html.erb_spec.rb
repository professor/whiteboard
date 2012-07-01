require 'spec_helper'

describe 'mailing_lists/index' do
  before(:each) do
    login(FactoryGirl.create(:student_sam))
    assign(:mailing_lists, ["staff-faculty@sv.cmu.edu", "allstudents@sv.cmu.edu"])
  end

  it "renders a list of mailing lists" do
    render
  end


end