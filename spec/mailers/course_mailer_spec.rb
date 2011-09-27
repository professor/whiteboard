require "spec_helper"

describe CourseMailer do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end
  it "should send IT email" do
    course = Factory(:course, :configure_course_twiki => true)
    mail = CourseMailer.configure_course_admin_email(course).deliver
    ActionMailer::Base.deliveries.size.should == 1
    mail.subject.should match(Regexp.new(course.name))
    mail.body.encoded.should match(Regexp.new(course.name))
  end

  it "should send faculty email" do
    course = Factory(:course, :configure_course_twiki => true)
    mail = CourseMailer.configure_course_faculty_email(course).deliver
    ActionMailer::Base.deliveries.size.should == 1
    mail.subject.should match(Regexp.new(course.name))
    mail.body.encoded.should match(Regexp.new(course.name))
  end
end
