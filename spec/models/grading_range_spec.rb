require 'spec_helper'

describe GradingRange do

  before(:each) do
    @grading_range = FactoryGirl.build(:grading_range)
  end

  it "should not have a value greater than 100" do
    @grading_range.minimum = 101
    @grading_range.should_not be_valid
  end

  it "should not have a value less than 0" do
    @grading_range.minimum = -1
    @grading_range.should_not be_valid
  end
end