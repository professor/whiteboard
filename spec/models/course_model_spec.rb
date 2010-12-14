require 'spec_helper'

describe Course do


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