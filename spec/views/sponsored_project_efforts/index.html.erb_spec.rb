require 'spec_helper'

describe 'sponsored_project_efforts/index' do
  before(:each) do
    effort = Factory(:sponsored_project_effort)

    assigns[:efforts] = [
        effort
    ]
    assigns[:month] = 3
    assigns[:year] = 2010
  end

  it "renders a list of efforts" do
    render
  end


end