require 'spec_helper'

describe "people/show.html.erb" do

    describe "Can not see last login location if not admin" do
        before(:each) do
            person = FactoryGirl.create(:student_sam, :linked_in => "iamsam", :facebook => "iamsam", :twitter => "iamsam", :google_plus => "https://plus.google.com/u/1/1234567890/", :github => "iamsam")
            login(person)
            assign(:person, person)
        end

        it "renders the page" do
            render
            render.should_not have_content('Last signed in')
        end
    end


    describe "Can see last login location if admin" do
        before(:each) do
            person = FactoryGirl.create(:admin_andy)
            login(person)
            assign(:person, person)
        end

        it "renders the page" do
            render
            render.should have_content('Last signed in')
        end
    end

end
