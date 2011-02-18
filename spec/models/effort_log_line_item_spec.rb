require 'spec_helper'

describe EffortLogLineItem do

  it 'can be created' do
    lambda {
      Factory(:effort_log_line_item)
      }.should change(EffortLogLineItem, :count).by(1)
    end


    context "is not valid" do    
      [:day1, :day2, :day3, :day4, :day5, :day6, :day7].each do |attr|
        it "when #{attr} is non-numerical" do
          effort_log_line_item = Factory.build(:effort_log_line_item, attr => "test")
          effort_log_line_item.should_not be_valid
        end
      end

      [:day1, :day2, :day3, :day4, :day5, :day6, :day7].each do |attr|
        it "when #{attr} is a negative number" do
          effort_log_line_item = Factory.build(:effort_log_line_item, attr => -1)
          effort_log_line_item.should_not be_valid
        end
      end
    end

    context "associations --" do
      [:effort_log, :task_type, :project, :course].each do |attr|
        it "belongs to a/an #{attr}" do
          subject.should respond_to(attr)
        end
      end
    end

    context "are ordered" do
      it "should be returned in the same order as inserted" do
        effort_log = Factory(:effort1)
        for i in 0..5
          Factory(:elli_line1, :task_type_id => i, :effort_log => effort_log)
        end
        
        i = 0
        effort_log.effort_log_line_items.each do |line|
          line.task_type_id.should == i
          i = i + 1
        end
      end
    end

  end
