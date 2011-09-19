require 'spec_helper'

describe Page do

  before(:all) do
#      activate_authlogic
  end

  before(:each) do
    @page = Page.new(:title => "Syllabus",
                     :updated_by_user_id => 10,
                     :tab_one_contents => "As a student in this course, you have the opportunity to practice principled software development in the context of an authentic project using an agile method. You track your progress against a plan and manage risks along the way. You prioritize features, do pair programming and follow test-driven development. You measure code coverage and code quality. Through this course, you experience the ins and outs of software engineering.")
    Page.any_instance.stub(:update_search_index)
    Page.any_instance.stub(:delete_from_search)
  end


  it "is valid with valid attributes" do
    sign_in(Factory(:faculty_frank))
    @page.should be_valid
  end

  it "is not valid without a title" do
    sign_in(Factory(:faculty_frank))
    @page.title = nil
    @page.should_not be_valid
  end

#   Not sure how to test this one since the invariant is upheld by the model with a before_validation
  it "is not valid without an updated_by_user_id"  do
    sign_in(u = Factory(:faculty_frank))
    @page.updated_by_user_id = nil
    lambda {
      @page.valid?
    }.should change(@page, :updated_by_user_id).from(nil).to(u.id)    
  end

  it "should allow faculty to upload attachments"


  it "should show who did the last edit and when it occurred" do
    sign_in(Factory(:faculty_frank))
    last_user_id = @page.updated_by_user_id
    @page.title = "Something different"
    @page.save
    latest_user_id = @page.updated_by_user_id
    Time.now.to_i.should be_within(100).of(@page.updated_at.to_i)
    UserSession.find.user.id.should == latest_user_id
  end

  context "can be a named url" do
    it "that is unique" do
      sign_in(Factory(:faculty_frank))
      @page.url = "ppm"
      @page.save

      @msp = Page.new(:title => "Syllabus",
                      :updated_by_user_id => 10,
                      :url => "ppm")
      @msp.should_not be_valid
      @msp.errors[:url].should_not be_blank
      @msp.errors[:url].should == ["has already been taken"]
    end

    it "that is not a number because it would cause conflicts with the id field on lookup" do
      sign_in(Factory(:faculty_frank))
      @page.url = "123"
      @page.should_not be_valid
      @page.errors[:url].should_not be_blank
#      @page.errors[:url].should == "has already been taken"
      @page.url = "test123"
      @page.should be_valid
      @page.errors[:url].should be_blank

      @page.url = "123test123test12321"
      @page.should be_valid
      @page.errors[:url].should be_blank
    end

    it "that defaults from the title field" do
      sign_in(Factory(:faculty_frank))
      @page.url = ""
      @page.should be_valid
      @page.url.should == @page.title      
    end

  end


  it "is editable by staff or admin" do
    @page.should be_editable(Factory(:faculty_frank))
   end

  it "is not editable unless they are staff or admin" do
    @page.should_not be_editable(Factory(:student_sam))
  end

  it "should allow the creator to specify editable by faculty or any authenticated user" do
    @page.should respond_to(:is_editable_by_all)
    @page.is_editable_by_all = true
    @page.should be_editable(Factory(:student_sam))    
  end
  

  it "is versioned" do
    sign_in(Factory(:faculty_frank))
    @page.should respond_to(:version)
    @page.save   
    version_number = @page.version
    @page.title = "A Brave New Title"
    @page.save
    @page.version.should == version_number + 1
  end

    it "should allow faculty to comment about the changes"
#  do
#      sign_in(Factory(:faculty_frank))
#      @page.version_comments = "A very simple change"
#      @page.save
##This seems too simple
#  end

  context "can determine its task number from the title" do
    it "without a number" do
      @page.task_number.should == nil
    end

    it "with a number" do
      @page.title = "Task 7: Something Wonderful"
      @page.task_number.should == "7"
    end
  end

  

  
end