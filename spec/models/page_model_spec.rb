require 'spec_helper'

describe Page do

  before(:each) do
    @page = Page.new(:title => "Syllabus",
                     :updated_by_user_id => 1,
                     :tab_one_contents => "As a student in this course, you have the opportunity to practice principled software development in the context of an authentic project using an agile method. You track your progress against a plan and manage risks along the way. You prioritize features, do pair programming and follow test-driven development. You measure code coverage and code quality. Through this course, you experience the ins and outs of software engineering.")
  end


#  it "is valid with valid attributes" do
#    @page.should be_valid
#  end
#
#  it "is not valid without a title" do
#    @page.title = nil
#    @page.should_not be_valid
#  end
#
#  it "is not valid without an updated_by_user_id" do
#    @page.updated_by_user_id = nil
#    @page.should_not be_valid
#  end

  it "is editable by faculty and staff"
    @page.should be_editable
#    @page.should_not be_editable?
#    user = stub('User', :is_faculty => true)
#    @page.stub(:current_user).and_return(user)


  
end