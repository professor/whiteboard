require 'spec_helper'

describe "In the grading queue," do
    before :all do
        @faculty = FactoryGirl.create(:faculty_frank_user)
        @faculty_not_me = FactoryGirl.create(:faculty_fagan_user)
        @student_sally = FactoryGirl.create(:student_sally)
        @student_sam = FactoryGirl.create(:student_sam)
        @team = FactoryGirl.create(:team_triumphant, :members => [@student_sally], :primary_faculty => @faculty )
        @team_not_mine = FactoryGirl.create(:team_bean_counters, :members => [@student_sam], :primary_faculty => @faculty_not_me )
        @course = FactoryGirl.create(:fse)
        @faculty_assignment = FactoryGirl.create(:faculty_assignment,:user => @faculty , :course => @course)
        @course.faculty_assignments << @faculty_assignment
        @assignment = FactoryGirl.create(:assignment, :is_team_deliverable => true, :course => @course)
        
        @deliverable = FactoryGirl.create(:deliverable, :assignment => @assignment , :team => @team, :course => @course, :creator => @student_sally)   
        @deliverable_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable, :submitter => @student_sally )
        @deliverable_not_mine = FactoryGirl.create(:deliverable, :assignment => @assignment , :team => @team_not_mine, :course => @course, :creator => @student_sam)   
        @deliverable_attachment_not_mine = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_not_mine, :submitter => @student_sam )

        login_with_oauth @faculty
    end

    before :each do
        visit("/courses/#{@course.id}/deliverables")
    end

    it "should have a radio button group which has two items: My Team and All" do
        page.should have_content("My Teams")
        page.should have_content("All Teams")
    end

    it "should have a column that indicates who is responsible for grading this deliverable" do
        page.should have_css('#tab-1', :text => 'Advisor')
    end

    it "should have checkboxes that provide different filtering conditions by assignment status" do
        page.should have_css('#filter_ungraded')
        page.should have_css('#filter_graded')
        page.should have_css('#filter_drafted')
    end

    it "Should have a selector that provide different filtering conditions by assignments" do
        page.should have_css('#selected_assignment')
    end

    context "if students have submitted assignments, it" do
        it "should shows submitted assignments, their owner, and the faculty who is responisble for" do
            page.should have_content(@team.name)
            page.should have_content(@team_not_mine.name)
            page.should have_content(@team.primary_faculty.human_name)
            page.should have_content(@team_not_mine.primary_faculty.human_name)
        end

        it "should have a column that indicates the grading status of each assignment" do
            page.should have_css('#tab-1', :text => 'Indicator')
            page.should have_css('#ungraded', :count => 2)
        end
    end

    context "as a faculty, it" do
        it "should not show assignments that I'm not responsible for after selecting My Team" do
            choose('filter_my_teams')
            expect(page).not_to have_content("Team Bean Counters")
        end
    end

end
