require 'spec_helper'
require_relative '../../app/services/people_in_a_collection.rb'

describe PeopleInACollection do

    context "when adding faculty to a course by providing their names as strings" do
      before(:each) do
        @course = FactoryGirl.build(:course)

        @faculty_frank = FactoryGirl.build(:faculty_frank, :id => rand(100))
        @faculty_fagan = FactoryGirl.build(:faculty_fagan, :id => rand(100) + 100)
        User.stub(:find_by_human_name).with(@faculty_frank.human_name).and_return(@faculty_frank)
        User.stub(:find_by_human_name).with(@faculty_fagan.human_name).and_return(@faculty_fagan)
        User.stub(:find_by_human_name).with("Someone not in the system").and_return(nil)
      end

      it "validates that the people are in the system" do
        @course.faculty_assignments_override = [@faculty_frank.human_name, @faculty_fagan.human_name]
        @course.validate_members :faculty_assignments_override
        @course.valid?
        @course.should be_valid
        tmp = 1
      end

      it "for people not in the system, it sets an error" do
        @course.faculty_assignments_override = [@faculty_frank.human_name, "Someone not in the system", @faculty_fagan.human_name]
        @course.validate_members :faculty_assignments_override
        @course.should_not be_valid
        @course.errors[:base].should include("Person Someone not in the system not found")
      end

      it "assigns them to the faculty association" do
        @course.faculty_assignments_override = [@faculty_frank.human_name, @faculty_fagan.human_name]
        @course.update_faculty
        @course.update_collection_members :faculty_assignments_override, :faculty

        @course.faculty[0].should == @faculty_frank
        @course.faculty[1].should == @faculty_fagan
      end
    end

end
