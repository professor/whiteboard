require "spec_helper"

describe "deliverables" do
  before do

    @assignment = FactoryGirl.create(:assignment_team)
    @team_deliverable = FactoryGirl.create(:team_deliverable)
    @user = @team_deliverable.team.members[0]
    @grade =  FactoryGirl.create(:grade_visible, :course_id => @assignment.course.id)
    Assignment.stub(:list_assignments_for_student).with(@user.id, :current).and_return([@assignment])
    Assignment.stub(:list_assignments_for_student).with(@user.id, :past).and_return([@assignment])
    @assignment.stub(:deliverables).and_return([@team_deliverable])
    @assignment.stub(:get_student_grade).with(@user.id).and_return(@grade)
    @assignment.stub(:get_student_deliverable).with(@user.id).and_return(@team_deliverable)
    @assignment.stub(:maximum_score).and_return(20.0)
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

    it " I can not be able to view professor's notes" do
      grade = @grade.score + "/" + @assignment.maximum_score.to_s
      page.should have_content(grade)
      click_link "Resubmit"
   #   visit deliverable_path(@team_deliverable)

      page.should have_content("Attachment Version History")
      page.should_not have_content("Professor's Notes")
      page.should_not have_content("My private notes")
    end


    context "when I submit an assignment," do
      before {
        @assignment = FactoryGirl.create(:assignment)
        @course_mfse = FactoryGirl.create(:mfse)
        Registration.create(user_id: @user.id, course_id: @assignment.course.id)
      }

      it "I see all my registered courses " do
        # Add one for the empty option
        visit new_deliverable_path
        page.should have_selector("select#deliverable_course_id > option", count: @user.registered_for_these_courses_during_current_semester.count)
      end

      context "with course_id and assignment_id from the url" do
        before {
          visit new_deliverable_path(course_id: @assignment.course.id, assignment_id: @assignment.id)
        }

        it "it should save when an attachment is present", :skip_on_local_machine => false do
          attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/sample_assignment.txt'
          expect { click_button 'Create' }.to change(Deliverable, :count).by(1)
        end

        it "should not save when there is no attachment" do
          expect { click_button 'Create' }.to_not change(Deliverable, :count)

          page.should have_selector("h1", text: "New deliverable")
          page.should have_selector(".ui-state-error")
        end
      end

      it "without course_id and assignment_id selected, then it should not save" do
        visit new_deliverable_path
        expect { click_button 'Create' }.to change(Deliverable, :count).by(0)

        page.should have_selector("h1", text: "New deliverable")
        page.should have_selector(".ui-state-error")
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


  it "test user" do
    @student1 = FactoryGirl.create(:student_sam_user)
    @student2 = FactoryGirl.create(:student_sam_user)
    @student1.should == @student2
  end

  context "Professor deliverables" do
    context "grading team deliverable" do
      before {
        @team = @team_deliverable.team
        @assignment = FactoryGirl.create(:assignment, is_team_deliverable: true, course: @team.course)
        Registration.create(user_id: @user.id, course_id: @assignment.course.id)
        login_with_oauth @user
        visit new_deliverable_path(course_id: @assignment.course.id, assignment_id: @assignment.id)
        attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/sample_assignment.txt'
        click_button "Create"
        @professor = FactoryGirl.create(:faculty_frank_user)
        @assignment.course.faculty_assignments_override = [@professor.human_name]
        @assignment.course.update_faculty
#        Course.any_instance.stub(:faculty).and_return([@professor])
        visit "/logout"
        login_with_oauth @professor
        # visit deliverable_feedback_path(Deliverable.last)  #if we separate out the feedback page
        visit deliverable_path(Deliverable.last)
        save_and_open_page
        page.should have_content("Grade Team Deliverable")
      }

      #it "should provide feedback and a grade to each student in the team" do
      #  fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
      #  click_button "Submit"
      #  Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
      #  Deliverable.last.status.should == 'Graded'
      #end
      #
      #it "should save as draft" do
      #  fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
      #  click_button "Save as draft"
      #  Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
      #  Deliverable.last.status.should == 'Draft'
      #end
    end

    #context "grading individual deliverables" do
    #  before {
    #    @assignment = FactoryGirl.create(:assignment, is_team_deliverable: false)
    #    Registration.create(user_id: @user.id, course_id: @assignment.course.id)
    #    login_with_oauth @user
    #    visit new_deliverable_path(course_id: @assignment.course.id, assignment_id: @assignment.id)
    #    attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/sample_assignment.txt'
    #    click_button "Create"
    #    @professor = FactoryGirl.create(:faculty_frank_user)
    #    @assignment.course.faculty_assignments_override = [@professor.human_name]
    #    @assignment.course.update_faculty
    #    login_with_oauth @professor
    #  }
    #
    #  it "should provide feedback and a grade to the student" do
    #    visit deliverable_feedback_path(Deliverable.last)
    #    page.should have_content("Grade Individual Deliverable")
    #    fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
    #    click_button "Submit"
    #    Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
    #    Deliverable.last.status.should == 'Graded'
    #  end
    #
    #  it "should save as draft" do
    #    visit deliverable_feedback_path(Deliverable.last)
    #    page.should have_content("Grade Individual Deliverable")
    #    fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
    #    click_button "Save as draft"
    #    Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
    #    Deliverable.last.status.should == 'Draft'
    #  end
    #
    #  context "unallowed access" do
    #    before {
    #      @dwight = FactoryGirl.create(:faculty_dwight_user)
    #      login_with_oauth @dwight
    #    }
    #
    #    it "should not allow unassigned faculty to grade" do
    #      visit deliverable_feedback_path(Deliverable.last)
    #      page.should have_selector('.ui-state-error')
    #    end
    #  end
    #end
  end
end
