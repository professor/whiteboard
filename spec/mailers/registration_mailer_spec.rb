require "spec_helper"

describe RegistrationMailer do
before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
	@student_sam = Factory(:student_sam)
	@student_sally  = Factory(:student_sally)
	@students = Array.new
	@students << @student_sam
	@students << @student_sally
	@faculty_frank = Factory(:faculty_frank)
	@course = Factory(:mfse)
end

  describe "When students are added from course" do
     it "should not deliver if no instructor is assigned" do
	   RegistrationMailer.notify_faculty_of_added_students('',@students,@course).deliver
	   ActionMailer::Base.deliveries.size == 0
	 end
	 
	 it "should deliver to one instructor" do
	    email = RegistrationMailer.notify_faculty_of_added_students(@faculty_frank.email,@students,@course).deliver
		faculty_list = Array.new()
		faculty_list << @faculty_frank.email
		ActionMailer::Base.deliveries.size.should == 1
		email.to.should == faculty_list
		email.subject.should == "Students added to course"
	 end
	 
	 it "should deliver to multiple instructors" do
		faculty_list = Array.new()
		faculty_list << @faculty_frank.email
		faculty_fagan = Factory(:faculty_fagan)
		faculty_list << faculty_fagan.email
		email = RegistrationMailer.notify_faculty_of_added_students(faculty_list,@students,@course).deliver
		ActionMailer::Base.deliveries.size.should == 1
		email.to.should == ['faculty.frank@sv.cmu.edu','faculty.fagan@sv.cmu.edu']
		email.subject.should == "Students added to course"
	 end
  end
  
  describe "When students are dropped from course" do
     it "should not deliver if no instructor is assigned" do
	   RegistrationMailer.notify_faculty_of_dropped_students('',@students,@course).deliver
	   ActionMailer::Base.deliveries.size == 0
	 end
	 
	 it "should deliver to one instructor" do
	    email = RegistrationMailer.notify_faculty_of_dropped_students(@faculty_frank.email,@students,@course).deliver
		faculty_list = Array.new()
		faculty_list << @faculty_frank.email
		ActionMailer::Base.deliveries.size.should == 1
		email.to.should == faculty_list
		email.subject.should == "Students have been dropped from course"
	 end
	 
	 it "should deliver to multiple instructors" do
		faculty_list = Array.new()
		faculty_list << @faculty_frank.email
		faculty_fagan = Factory(:faculty_fagan)
		faculty_list << faculty_fagan.email
		email = RegistrationMailer.notify_faculty_of_dropped_students(faculty_list,@students,@course).deliver
		ActionMailer::Base.deliveries.size.should == 1
		email.to.should == ['faculty.frank@sv.cmu.edu','faculty.fagan@sv.cmu.edu']
		email.subject.should == "Students have been dropped from course"
	 end

  end
end
