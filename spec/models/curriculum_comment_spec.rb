require 'spec_helper'

describe CurriculumComment do
  it "notifies instructors" do
    comment = CurriculumComment.new
    comment.url = "https://curriculum.sv.cmu.edu/architecture_se/task08/requirements.shtml"
    comment.semester = "Summer"
    comment.year = "2009"
    
    instructors_to_be_notified = comment.notify_instructors
    instructors_to_be_notified.length.should == 3
    instructors_to_be_notified.include?("Todd.Sedano@sv.cmu.edu").should be_true
    instructors_to_be_notified.include?("Reed.Letsinger@sv.cmu.edu").should be_true
    instructors_to_be_notified.include?("Ed.Katz@sv.cmu.edu").should be_true
    
    #no need to test any of the others as we are really only interested in the api to the method
    #as the logic is all hard coded
    
    #comment.url = "https://curriculum.sv.cmu.edu/mfse/task1/requirements.shtml"
    #assert_equal ["Martin.Radley@sv.cmu.edu"], comment.notify_instructors

    #comment.url = "https://curriculum.sv.cmu.edu/esm/task1/requirements.shtml"
    #assert_equal ["Gladys.Mercier@sv.cmu.edu", "Patricia.Collins@sv.cmu.edu"], comment.notify_instructors
  end
end