require "spec_helper"

describe "deliverables" do
  before do

    @assignment = FactoryGirl.create(:assignment_team)
    @team_deliverable = FactoryGirl.create(:team_deliverable)
    @user=@team_deliverable.team.members[0]
    @grade =  FactoryGirl.create(:grade_visible, :course_id => @assignment.course.id)
    Assignment.stub(:list_assignments_for_student).and_return([@assignment])
    @assignment.stub(:deliverables).and_return([@team_deliverable])
    @assignment.stub(:get_student_grade).with(@user.id).and_return(@grade)
    @assignment.stub(:get_student_deliverable).with(@user.id).and_return(@team_deliverable)
    @deliverableAttachment=DeliverableAttachment.create(:attachment_file_name=>"hi",:deliverable_id=>@team_deliverable.id,:submitter_id=>@user.id)

  end

  after do
    #@team_deliverable.delete
    #@user.delete
    #@deliverableAttachment.delete
  end

  context "As a student" do
    before do
     visit('/')
     login_with_oauth @user
     click_link "My Deliverables"
    end



    context "My deliverables" do
      it "renders my deliverables page" do
        page.should have_content("Listing Deliverables")
        page.should have_link("New deliverable")
      end

      it "lets the user create new deliverable"  do
        click_link "New deliverable"
        page.should have_content("New deliverable")
        page.should have_selector("select#deliverable_course_id")
        page.should have_button("Create")
      end
    end

    context "I should" do
      it " not be able to view professor's notes" do
        page.should have_content("View History and Feedback")
        click_link "View History and Feedback"
     #   visit deliverable_path(@team_deliverable)

        page.should have_content("Attachment Version History")
        page.should_not have_content("Professor's Notes")
        page.should_not have_content("My private notes")
      end
    end
  end


  context "As a professor" do
    before do
      @faculty = FactoryGirl.create(:faculty_fagan)
      login_with_oauth @faculty
      visit deliverable_path(@team_deliverable)
    end

    after do
      @faculty.delete
    end

    it "I should be able to view deliverable page" do
   #   page.should have_content("Deliverable for")
      page.should have_content("Attachment Version History")
      page.should have_content("Professor's Notes")
      page.should have_content("My private notes")
    end
  end
end
