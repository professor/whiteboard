require 'spec_helper'

describe "people/show.html.erb" do
    before(:each) do
        person = FactoryGirl.create(:student_sam, :linked_in => "iamsam", :facebook => "iamsam", :twitter => "iamsam", :google_plus => "https://plus.google.com/u/1/1234567890/", :github => "iamsam")
        login(person)
        assign(:person, person)
    end

    it "renders attributes in <p>" do
        render
    end

end
