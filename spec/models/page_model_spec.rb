require 'spec_helper'

describe PagesController do
  fixtures :users  


  before(:all) do
      activate_authlogic
  end

  before(:each) do
    @page = Page.new(:title => "Syllabus",
                     :updated_by_user_id => 10,
                     :tab_one_contents => "As a student in this course, you have the opportunity to practice principled software development in the context of an authentic project using an agile method. You track your progress against a plan and manage risks along the way. You prioritize features, do pair programming and follow test-driven development. You measure code coverage and code quality. Through this course, you experience the ins and outs of software engineering.")
  end


  it "is valid with valid attributes" do
    UserSession.create(users(:faculty_frank))
    @page.should be_valid
  end

  it "is not valid without a title" do
    UserSession.create(users(:faculty_frank))
    @page.title = nil
    @page.should_not be_valid
  end

  it "is not valid without an updated_by_user_id"
#   Not sure how to test this one since the invariant is upheld by the model with a before_validation
#  do
#    UserSession.create(users(:faculty_frank))
#    @page.updated_by_user_id = nil
#    @page.should_not be_valid
#  end

  it "should allow faculty to upload attachments"
#    setup :activate_authlogic
#    UserSession.create(users("FacultyFrank"))


  it "should show who did the last edit and when it occurred" do
    UserSession.create(users(:faculty_frank))
    last_user_id = @page.updated_by_user_id
    @page.title = "Something different"
    @page.save
    latest_user_id = @page.updated_by_user_id
    Time.now.to_i.should be_close @page.updated_at.to_i, 100
    UserSession.find.user.id.should == latest_user_id
  end

  it "should allow the creator to specify editable by faculty or any authenticated user"

  

  it "is editable by faculty and staff" 
  #do
#    @page.should_not be_editable
#    user = stub('User', :is_staff => true)
#    @page.stub(:current_user).and_return(user)
#    @page.should be_editable
#   end

    it "is versioned"
#  do
#    @page.save
#    version_number = @page.version
#    @page.title = "A Brave New Title"
#    @page.save
#    new_version_number = @page.version
#    @page.version.should == version_number + 1
#  end

    it "should allow faculty to comment about the changes"
#  do
#      UserSession.create(users(:faculty_frank))
#      @page.version_comments = "A very simple change"
#      @page.save
##This seems too simple
#  end


    it "should allow the creator to specify edit permissions as either anyone or faculty"

  

  
end