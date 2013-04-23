require 'spec_helper'

describe PeopleHelper do
    describe "social handles" do
        before(:each) do
            @person = double(Person)
            @person.stub(:linked_in){ "iamsam" }
            @person.stub(:facebook){ "iamsam" }
            @person.stub(:twitter){ "iamsam" }
            @person.stub(:google_plus){ "http://plus.google.com/1234567890" }
            @person.stub(:github){ "iamsam" }
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
            helper.google_plus_path(@person).should == "http://plus.google.com/1234567890"
        end
        it "should take in both https as well as http" do
            @person.stub(:google_plus){ "https://plus.google.com/1234567890" }
            helper.google_plus_path(@person).should == "https://plus.google.com/1234567890"
        end
    end
end
