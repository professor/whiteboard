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
      it "show score when grading criteria is percentage" do
        ppm_course = FactoryGirl.create(:ppm_current_semester)
        student = ppm_course.teams.first.members.first
        student.deliverable_grades.each do |deliverable_grade|
          deliverable_grade.update_attributes(grade: 1)
        end
        student.deliverable_grades.first.update_attributes(grade: "A")
        ppm_course.reload

        ppm_course.get_earned_number_grade(student).should == student.deliverable_grades.count + 99
      end

      it "show score when grading criteria is points" do
        architecture_course = FactoryGirl.create(:architecture_current_semester)
        student = architecture_course.teams.first.members.first
        student_deliverable_grades = student.deliverable_grades
        student_deliverable_grades[0].update_attributes(grade: 20)
        student_deliverable_grades[1].update_attributes(grade: 20)
        student_deliverable_grades[2].update_attributes(grade: "A") #(20)
        student_deliverable_grades[3].update_attributes(grade: "B") #(17.4)
        architecture_course.reload

        architecture_course.get_earned_number_grade(student).should == 77.4
      end
    end
  end
end