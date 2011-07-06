require 'spec_helper'

describe "system/index.html.erb" do
  before(:each) do
    login_user(Factory(:student_sam))
  end

  it "renders the system page" do
    render
  end
end
