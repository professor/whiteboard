require 'spec_helper'

describe UsersHelper do
    # describe "#twiki_user_link" do
    #   it "displays a link to the user's profile" do
    #     content = helper.twiki_user_link("AndrewCarnegie", "Andrew Carnegie")
    #     content.should include("<a href='http://rails.sv.cmu.edu/people/AndrewCarnegie'")
    #     content.should include("target='_top'")
    #     content.should include(">Andrew Carnegie</a>")
    #   end

    #   it "should not be a link when the Twiki name is empty" do
    #     content = helper.twiki_user_link("", "Andrew Carnegie")
    #     content.should == "Andrew Carnegie"

    #     content = helper.twiki_user_link(nil, "Andrew Carnegie")
    #     content.should == "Andrew Carnegie"
    #   end
    # end

    describe "social handles" do
        before(:each) do
            @person = FactoryGirl.create(:student_sam, :linked_in => "iamsam", :facebook => "iamsam", :twitter => "iamsam", :google_plus => "https://plus.google.com/u/1/1234567890", :github => "iamsam")
        end
        it "should take in a LinkedIn handle and properly format the url" do
            helper.linked_in_path(@person).should == "http://www.linkedin.com/in/iamsam"
        end
        it "should take in a Facebook handle and properly format the url" do
            helper.facebook_path(@person).should == "http://www.facebook.com/iamsam"
        end
        it "should take in a Twitter handle and properly format the url" do
            helper.twitter_path(@person).should == "http://www.twitter.com/iamsam"
        end
        it "should take in a Google+ handle and properly format the url" do
            helper.google_plus_path(@person).should == "http://plus.google.com/u/1/1234567890"
        end
    end
end
