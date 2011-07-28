require 'spec_helper'

describe 'sponsored_project_allocations/index' do
  before(:each) do
    allocation = Factory(:sponsored_project_allocation)

    assign(:allocations, [
        allocation
    ])
  end

  it "renders a list of allocations" do
    render
  end
  

end