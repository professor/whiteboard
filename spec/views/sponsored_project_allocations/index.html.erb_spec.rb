require 'spec_helper'

describe 'sponsored_project_allocations/index' do
  before(:each) do
    allocation = Factory.build(:sponsored_project_allocation)

    assigns[:allocations] = [
#        allocation,
        allocation
    ]
  end

  it "renders a list of allocations" do
    render
  end
  

end