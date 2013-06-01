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
  context "assignment list" do
    before do
      @courses = []
      @current_assignments = []
      @past_assignments = []
      @assignments = []
      @students = []
      2.times.each do |student|
        @students << FactoryGirl.create(:student_john_user)
      end

      4.times.each do |course|
        if course < 2
          course = FactoryGirl.create(:course, :registered_students=>@students, :year => Date.today.year)
          @current_assignments << FactoryGirl.create(:assignment, :course_id=>course.id)
          @current_assignments << FactoryGirl.create(:assignment_team, :course_id=>course.id)
          @current_assignments << FactoryGirl.create(:assignment_unsubmissible, :course_id=>course.id)
        else
          course = FactoryGirl.create(:course, :registered_students=>@students, :year => Date.today.year-1)
          @past_assignments << FactoryGirl.create(:assignment, :course_id=>course.id)
          @past_assignments << FactoryGirl.create(:assignment_team, :course_id=>course.id)
          @past_assignments << FactoryGirl.create(:assignment_unsubmissible, :course_id=>course.id)
        end
        @courses << course
      end
      @assignments = @current_assignments + @past_assignments
    end

    it "List Student's all assignments" do
      all = Assignment.list_assignments_for_student(@students[0].id).sort_by {|a| a.id}
      all.should eq(@assignments)
    end
    it "List Student's current assignments" do
      curr = Assignment.list_assignments_for_student(@students[0].id, :current).sort_by {|a| a.id}
      curr.should eq(@current_assignments)
    end
    it "List Student's past assignments" do
      past = Assignment.list_assignments_for_student(@students[0].id, :past).sort_by {|a| a.id}
      past.should eq(@past_assignments)
    end

    it "can get student's deliverable for individual assignment " do
      deliverable = FactoryGirl.create(:individual_deliverable, :assignment_id => @assignments[0].id, :creator_id => @students[0].id)
      @assignments[0].get_student_deliverable(@students[0].id).should  eq(deliverable)
    end

    it "can get student's deliverable for team assignment " do
      team = FactoryGirl.create(:team, :course_id=>@courses[0].id)
      team.members = @students
      deliverable = FactoryGirl.create(:team_deliverable, :assignment_id => @assignments[1].id, :team_id=>team.id, :creator_id => @students[0].id)
      @assignments[1].get_student_deliverable(@students[0].id).should eq(deliverable)
      @assignments[1].get_student_deliverable(@students[1].id).should eq(deliverable)
    end

    it "can get student's grade for an assignment " do
      grade = FactoryGirl.create(:grade, :assignment_id => @assignments[0].id, :student_id => @students[0].id, :course_id=>@courses[0].id)
      @assignments[0].get_student_grade(@students[0].id).should eq(grade)
    end

  end

  context "Assignment Order" do
    before do
      @course = FactoryGirl.create(:course)
    end

    it "should increment automatically by 1 for specific course" do

      course2 = FactoryGirl.create(:mfse)
      course_assignment1 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      course_assignment2 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      course2_assignment1 = FactoryGirl.create(:assignment, :task_number => 1, :course => course2)
      course_assignment1.assignment_order.should eq(1)
      course_assignment2.assignment_order.should eq(2)
      course2_assignment1.assignment_order.should eq(1)

    end

    it "should increment automatically by 1 if there are other assignment added" do
      @task1_assignment1 = FactoryGirl.create(:assignment, :task_number => 1, :course => @course)
      @task1_assignment2 = FactoryGirl.create(:assignment, :task_number => 2, :course => @course)
      @task1_assignment2.assignment_order.should eq(2)
    end

    it "should be assignned  even if the task number is blank" do
      @assignment1 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      @assignment2 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      @assignment1.assignment_order.should eq(1)
      @assignment2.assignment_order.should eq(2)
    end

    it "should re-order the assignment order number when reposition is called" do
      @assignment1 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      @assignment2 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      @assignment3 = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      desired_order = [@assignment3.id, @assignment2.id, @assignment1.id]
      Assignment.reposition(desired_order)
      new_order = Assignment.all.collect(&:id)
      new_order.should eq(desired_order)
    end
  
  end
  context "Delete Assignment" do
    before :each do
      @course = FactoryGirl.create(:course)
    end
    it "should be able to delete assignment if no student submit for it" do
      assignment = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
      before_delete = Assignment.count
      assignment.destroy
      Assignment.count.should eq(before_delete-1)
    end
    it "should not be able to delete assignment if student submit for it"  do
      deliverable=FactoryGirl.create(:deliverable)
      assignment = FactoryGirl.create(:assignment, :task_number => nil, :course => @course, :deliverables => [deliverable])
      before_delete = Assignment.count
      assignment.destroy
      Assignment.count.should eq(before_delete)
    end

  end

  context "Due date of Assignment" do
    before :each do
      @course = FactoryGirl.create(:course)
      @assignment = FactoryGirl.create(:assignment, :task_number => nil, :course => @course)
    end

    it "should have a due date when update" do
      @assignment.set_due_date("2013-12-3", "05", "02")
      @assignment.due_date.strftime("%Y-%m-%d %H:%M").should == "2013-12-03 05:02"
    end

    it "should be blank if the date is blank" do
      @assignment.set_due_date("", "05", "02")
      @assignment.due_date.blank?.should == true
    end

    it "should be 10 PM if the hour and minute values are blank" do
      @assignment.set_due_date("2013-12-3", "", "")
      @assignment.due_date.strftime("%Y-%m-%d %H:%M").should == "2013-12-03 22:00"
    end

    it "should be 10 PM if an hour value is not entered" do
      @assignment.set_due_date("2013-12-3", "", "10")
      @assignment.due_date.strftime("%Y-%m-%d %H:%M").should == "2013-12-03 22:00"
    end

    it "should be reset to 0 minutes if only an hour value is entered" do
      @assignment.set_due_date("2013-12-3", "13", "")
      @assignment.due_date.strftime("%Y-%m-%d %H:%M").should == "2013-12-03 13:00"
    end

  end
end
