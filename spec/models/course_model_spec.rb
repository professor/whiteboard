require 'spec_helper'

describe Course do

  Factory.define :course, :class => Course do |c|
    c.name 'Course'
    c.semester ApplicationController.current_semester
    c.year  Date.today.year
    c.mini 'Both'
   end

  Factory.define :fse, :parent => :course do |c|
    c.name 'Foundations of Software Engineering'
    c.short_name 'FSE'
  end

  Factory.define :mfse, :parent => :course do |c|
    c.name 'Foundations of Software Engineering'
    c.short_name 'MfSE'
    c.semester ApplicationController.next_semester
    c.year ApplicationController.next_semester_year
  end



  it "should know which courses are offered this semester" do
    list = Course.current_semester_courses
    course = Factory(:fse)
    list2 = Course.current_semester_courses
    list.length.should be_equal list2.length - 1

  end

  it "should know which courses are offered next semester" do
    list = Course.next_semester_courses
    course = Factory(:mfse)
    list2 = Course.next_semester_courses
    list.length.should be_equal list2.length - 1
  end
    
  


  
end