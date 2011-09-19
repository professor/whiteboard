require 'spec_helper'

describe "mailing_lists/show.html.erb" do
  before(:each) do
    person = Factory(:student_sam)
    sign_in(person)
    assign(:mailing_list, "staff-faculty@sv.cmu.edu")
    assign(:members, ["andrew.carnegie@west.cmu.edu", "andrew.mellon@west.cmu.edu"] )
  end

  it "renders mailing list members" do
    render
  end
end
