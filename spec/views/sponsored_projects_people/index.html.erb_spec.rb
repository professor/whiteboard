require 'spec_helper'

describe 'sponsored_projects_people/index' do
  before(:each) do
    allocation = Factory.build(:sponsored_project_people)

    assigns[:allocations] = [
        allocation,
        allocation
    ]
  end

  it "renders a list of allocations" do
    render
  end
  

end