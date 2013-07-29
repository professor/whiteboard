# require 'spec_helper'
require_relative "../../app/helpers/people_helper"

class Person; end


describe PeopleHelper do
    describe "social handles" do

        before(:each) do
            @person = double(Person)
            @person.extend(PeopleHelper)
        end

        it "takes in all combinations and format the url correctly for Facebook" do
            [   "http://www.facebook.com/iamsam",
                "www.facebook.com/iamsam",
                "http://facebook.com/iamsam",
                "http://www.facebook.com/iamsam",
                "facebook.com/iamsam",
                "http://www.facebook.com/iamsam",
                "facebook.com/iamsam"
            ].each do |url_input|
              @person.stub(:facebook){ url_input }
              @person.facebook_path(@person).should == "http://www.facebook.com/iamsam"
            end

            [   "https://www.facebook.com/iamsam",
                "https://facebook.com/iamsam"
            ].each do |url_input|
              @person.stub(:facebook){ url_input }
              @person.facebook_path(@person).should == "https://www.facebook.com/iamsam"
            end
        end

        it "takes in Twitter urls and formats the url correctly" do
            @person.stub(:twitter){ "iamsam" }
            @person.twitter_path(@person).should == "http://www.twitter.com/iamsam"
        end

        it "takes in github urls and formats the url correctly" do
            @person.stub(:github){ "iamsam" }
            @person.github_path(@person).should == "http://www.github.com/iamsam"
        end

        it "takes in all combinations and format the url correctly for LinkedIn" do
            [   "http://www.linkedin.com/in/iamsam",
                "www.linkedin.com/in/iamsam",
                "http://linkedin.com/in/iamsam",
                "http://www.linkedin.com/in/iamsam",
                "linkedin.com/in/iamsam",
                "http://www.linkedin.com/in/iamsam",
                "linkedin.com/in/iamsam"
            ].each do |url_input|
              @person.stub(:linked_in){ url_input }
              @person.linked_in_path(@person).should == "http://www.linkedin.com/in/iamsam"
            end

            [   "https://www.linkedin.com/in/iamsam",
                "https://linkedin.com/in/iamsam"
            ].each do |url_input|
              @person.stub(:linked_in){ url_input }
              @person.linked_in_path(@person).should == "https://www.linkedin.com/in/iamsam"
            end
        end

        it "takes in Google+ urls and formats the url correctly" do

            [   "http://plus.google.com/1234567890",
                "www.plus.google.com/1234567890",
                "http://www.plus.google.com/1234567890",
                "plus.google.com/1234567890",
                "http://www.plus.google.com/1234567890",
                "plus.google.com/1234567890",

                "http://plus.google.com/1234567890/posts",
                "www.plus.google.com/1234567890/posts",
                "http://www.plus.google.com/1234567890/posts",
                "plus.google.com/1234567890/posts",
                "http://www.plus.google.com/1234567890/posts",
                "plus.google.com/1234567890/posts"
            ].each do |url_input|
                @person.stub(:google_plus){ url_input }
                @person.google_plus_path(@person).should == "http://plus.google.com/1234567890"
            end
            [   "https://plus.google.com/1234567890/posts",
                "https://plus.google.com/1234567890",
                "https://www.plus.google.com/1234567890",
                "https://www.plus.google.com/1234567890/posts"
            ].each do |url_input|
                @person.stub(:google_plus){ url_input }
                @person.google_plus_path(@person).should == "https://plus.google.com/1234567890"
            end
        end

    end
end
