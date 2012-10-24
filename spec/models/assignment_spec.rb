require 'spec_helper'

describe Assignment do

  context "validate assignments" do
    [:maximum_score, :course_id].each do  |attr|
        it "without #{attr} not valid" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
    end
    it {should belong_to(:course)}
    it {should have_many(:grades)}
  end
  
  context "maximum score" do
    it "should be a number" do
      subject.maximum_score = "just for test"
      subject.maximum_score.should_not  be_a(Fixnum)
      subject.should_not be_valid
    end  

    it 'should not be negative' do
      subject.maximum_score = -1.0 
      subject.should_not be_valid
    end
  end

  context "Assignment Order" do
    before do
      @course = FactoryGirl.create(:course)
    end

    it "should assign assignment_order as 1 for each new task number" do
      @assignment = FactoryGirl.create(:assignment, :task_number=> 1, :course => @course)
      @task2_assignment1 = FactoryGirl.create(:assignment, :task_number => 2, :course => @course)
      @assignment.assignment_order.should eq(1)
      @task2_assignment1.assignment_order.should eq(1)
    end 
    
    it "should increment automatically by 1 if there are other assignment with the same task number " do
      @task1_assignment1 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      @task1_assignment2 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      @task1_assignment2.assignment_order.should eq(2)
    end
    

    it "should increment by 1 on the basis of task number" do
      @task1_assignment1 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      @task2_assignment1 = FactoryGirl.create(:assignment, :task_number => 2, :course => @course)
      @task1_assignment2 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      @task1_assignment2.assignment_order.should eq(2)
    end 
    
    it "should be assignned  even if the task number is blank" do
      @assignment1 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      @assignment2 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      @assignment1.assignment_order.should eq(1)
      @assignment2.assignment_order.should eq(2)
    end
  
  end
end
