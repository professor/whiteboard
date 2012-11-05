require "spec_helper"

describe "courses" do

  context "current courses" do
    before do
      visit('/')
      @user = FactoryGirl.create(:student_sam)
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      login_with_oauth @user
      click_link "#{@semester} #{@year}" " Courses"
    end

    it "renders current courses page" do
      page.should have_content("#{@semester} #{@year}" " Courses")
      page.should have_selector("input#filterBoxOne")
      page.should have_link("course selections")
    end

    it "defaults to a listing of all courses in the semester" do
        page.should have_selector("#courses_for_a_semester")
    end

    it "toggles to a visual representation of courses" do
      click_link "Show courses by minis"
      page.should have_selector("#courses_by_length")
    end

    context "all courses" do
      it 'renders all courses' do
        click_link "Courses"
        page.should have_content("All Courses")
        page.should have_link("See current semester")
      end
    end
  end

  context "configuring grading range" do
    before do
      visit('/')
      @user = FactoryGirl.create(:faculty_frank_user)
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      login_with_oauth @user
      click_link "#{@semester} #{@year}" " Courses"
      @course = FactoryGirl.create(:course)
      visit configure_course_path(@course)
    end

    it "should reach the right course configuration page" do
      page.should have_content("Configure your course, #{@course.name}")
    end

    it "should have grading range table" do
      page.should have_selector("table#grading_range > tbody > tr", count: GradingRange.possible_grades.count)
      page.should have_selector("table#grading_range > tbody > tr:first > td", count: 3)
    end

    it 'should save when numerical values are entered' do
      @course.grading_ranges.each_with_index do |grading_range, index|
        fill_in "course_grading_ranges_attributes_#{index}_minimum", with: grading_range['minimum'] + 1
      end

      click_button "Update Grading Criteria"
      @course.reload
      GradingRange.possible_grades.each_with_index do |(grade, value), index|
        @course.grading_ranges[index][:minimum].should == value + 1
      end
    end

    it 'should not save when less than 2 grades are enabled' do
      @course.grading_ranges.each_with_index do |grading_range, index|
        find(:css, "#course_grading_ranges_attributes_#{index}_active").set(false)
      end

      click_button "Update Grading Criteria"
      page.should have_selector("#error_explanation", content: "Less than 2 active ranges")
    end

    it 'should not save when grades are not descending' do
      @course.grading_ranges.each_with_index do |grading_range, index|
        find(:css, "#course_grading_ranges_attributes_#{index}_active").set(false)
      end

      find(:css, "#course_grading_ranges_attributes_0_active").set(true)
      fill_in "course_grading_ranges_attributes_0_minimum", with: 90
      find(:css, "#course_grading_ranges_attributes_1_active").set(true)
      fill_in "course_grading_ranges_attributes_1_minimum", with: 95
      click_button "Update Grading Criteria"

      page.should have_selector("#error_explanation", content: "Number values must be descending by descending grades")
    end
  end

  context "gradebook" do
    context "student's final score" do
      it 'testing with rspec' do
        @architecture_course = FactoryGirl.create(:architecture_current_semester)

        STDERR.puts "Teams: #{@architecture_course.teams.count}"
        STDERR.puts "Team inspect: #{@architecture_course.teams.inspect}"
        @architecture_course.teams.each { |team| STDERR.puts "Team count: #{team.members.count}" }
        STDERR.puts "Assignment count: #{@architecture_course.assignments.count}"
        STDERR.puts "Assignment inspect: #{@architecture_course.assignments.inspect}"

        @architecture_course.assignments.each do |assignment|
          STDERR.puts "@@@@@@@@@@@ #{assignment.title} @@@@@@@@@@@"
          STDERR.puts "Deliverable count: #{assignment.deliverables.count}"
          STDERR.puts "Deliverable inspect: #{assignment.deliverables.inspect}"
        end
      end

      it "show score when grading criteria is percentage" do
        @course = FactoryGirl.create(:course, grading_criteria: "Percentage")
        @course.faculty = [FactoryGirl.create(:faculty_frank)]
        @course.save
        @team = FactoryGirl.create(:team, course: @course)
        @student = @team.members.first
        @student.registered_courses = [@course]
        @student.save
        @course.reload
        @assignment1 = FactoryGirl.create(:assignment, course: @course, weight: 40, team_deliverable: false)
        @assignment2 = FactoryGirl.create(:assignment, course: @course, weight: 30, team_deliverable: true)
        @assignment3 = FactoryGirl.create(:assignment, course: @course, weight: 20, team_deliverable: false, can_submit: false)
        @assignment4 = FactoryGirl.create(:assignment, course: @course, weight: 10, team_deliverable: true, can_submit: false)
        @deliverable1 = FactoryGirl.create(:deliverable, assignment: @assignment1, creator: @student)
        @deliverable2 = FactoryGirl.create(:deliverable, assignment: @assignment2, creator: @student, team: @team)
        @deliverable1.deliverable_grades.create(user: @student, grade: 40)
        @deliverable2.deliverable_grades.create(user: @student, grade: 20)
        @assignment3.deliverables.first.deliverable_grades.find_by_user_id(@student.id).update_attributes(grade: 15)
        @assignment4.deliverables.first.deliverable_grades.find_by_user_id(@student.id).update_attributes(grade: 5)

        @course.get_earned_number_grade(@student).should == 80
      end

      it "show score when grading criteria is points" do
        @course = FactoryGirl.create(:course, grading_criteria: "Points")
        @course.faculty = [FactoryGirl.create(:faculty_frank)]
        @course.save
        @team = FactoryGirl.create(:team, course: @course)
        @student = @team.members.first
        @student.registered_courses = [@course]
        @student.save
        @course.reload
        @assignment1 = FactoryGirl.create(:assignment, course: @course, weight: 40, team_deliverable: false)
        @assignment2 = FactoryGirl.create(:assignment, course: @course, weight: 70, team_deliverable: true)
        @assignment3 = FactoryGirl.create(:assignment, course: @course, weight: 60, team_deliverable: false, can_submit: false)
        @assignment4 = FactoryGirl.create(:assignment, course: @course, weight: 30, team_deliverable: true, can_submit: false)
        @deliverable1 = FactoryGirl.create(:deliverable, assignment: @assignment1, creator: @student)
        @deliverable2 = FactoryGirl.create(:deliverable, assignment: @assignment2, creator: @student, team: @team)
        @deliverable1.deliverable_grades.create(user: @student, grade: 20)
        @deliverable2.deliverable_grades.create(user: @student, grade: 35)
        @assignment3.deliverables.first.deliverable_grades.find_by_user_id(@student.id).update_attributes(grade: 30)
        @assignment4.deliverables.first.deliverable_grades.find_by_user_id(@student.id).update_attributes(grade: 15)

        @course.get_earned_number_grade(@student).should == 50
      end
    end
  end
end