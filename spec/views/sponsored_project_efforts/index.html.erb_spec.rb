require 'spec_helper'

describe 'sponsored_project_efforts/index' do
  before(:each) do
    effort = Factory(:sponsored_project_effort)

    assign(:efforts, [
        effort
    ])
    assign(:month, 3)
    assign(:year, 2010)
  end

  it "renders a list of efforts" do
    render
  end


end