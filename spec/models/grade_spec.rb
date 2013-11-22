require 'spec_helper'

describe Grade do
  before(:each) do
    @student_sam = FactoryGirl.create(:student_sam_user)
    @course_fse = FactoryGirl.create(:course_fse_with_students, registered_students: [@student_sam])
    @course_grading_rule = FactoryGirl.create(:grading_rule_points, :course_id => @course_fse.id)
    @course_fse.grading_rule = @course_grading_rule
    @course_grading_rule.save

    Course.any_instance.stub(:registered_students_or_on_teams).and_return([@student_sam])

    @assignment_1 = FactoryGirl.create(:assignment_fse)
    @course_fse.assignments << @assignment_1

    @assignment_2 = FactoryGirl.create(:assignment)
    @course_fse.assignments << @assignment_2

    @grade = Grade.create(:course_id => @course_fse.id, 
                                   :student_id => @student_sam.id, 
                                   :assignment_id => @assignment_1.id,
                                   :score => "0")
    User.stub(:find).with(@student_sam.id).and_return(@student_sam)
    @course_fse.grading_rule.stub(:validate_score).and_return(true)
  end

  after(:each) do
    @student_sam.delete
    @course_fse.delete
    @assignment_1.delete
    @assignment_2.delete
    @grade.delete
  end

  subject { @grade }

  context "Grade" do
    it { should belong_to(:course)}
    it { should belong_to(:student)}
    it { should belong_to(:assignment)}
  end
  
  context "course_id" do
    its (:course_id) { should == @course_fse.id }
    
    it "should not be nil" do
      subject.course_id = nil
      subject.should_not be_valid
    end

    it "should not be blank" do
      subject.course_id = ""
      subject.should_not be_valid
    end
  end
  
  context "student_id" do
    its (:student_id) {should == @student_sam.id}

    it "should not be nil" do
      subject.student_id = nil
      subject.should_not be_valid
    end

    it "should not be blank" do
      subject.student_id = ""
      subject.should_not be_valid
    end
  end

  context "assignment_id" do
    its (:assignment_id) {should == @assignment_1.id}
    
    it "should not be nil" do
      subject.assignment_id = nil
      subject.should_not be_valid
    end

    it "should not be blank" do
      subject.assignment_id = ""
      subject.should_not be_valid
    end
  end

  context "assignment grades" do
    it 'should not be redundant' do
      redundant_grade = Grade.new(
        :course_id => @course_fse.id,
        :student_id => @student_sam.id,
        :assignment_id => @assignment_1.id,
        :score => "0")
      redundant_grade.should_not be_valid
    end

    it 'should be able to fetch one student\'s grades' do
      all_grades = Grade.get_grades_for_student_per_course(@course_fse, @student_sam)
      subject.should eql(all_grades[@assignment_1.id])
    end

    it 'should be able to fetch one student\'s grade earned from one assignment' do
      @grade.save
      score_value = {:course_id=>@course_fse.id, :student_id=>@student_sam.id, :assignment_id=>@assignment_1.id}
      one_grade = Grade.get_grade(@course_fse.id, @assignment_1.id, @student_sam.id)
      @grade.eql?(one_grade)
    end

    it "should be able to give new grade to a registered student" do
      score = "10"
      Grade.give_grade(@course_fse.id, @assignment_2.id, @student_sam.id, score).should be_true
      Grade.find_by_assignment_id_and_student_id(@assignment_2.id,@student_sam.id).score.should eq(score)
    end

    it "should be able to give a updated grade to a registered student" do
      score = "10"
      Grade.give_grade(@course_fse.id, @assignment_1.id, @student_sam.id, score).should be_true
      Grade.find_by_assignment_id_and_student_id(@assignment_1.id, @student_sam.id).score.should eq(score)
    end

    it "should not give grade to an unregistered student" do
      score = "10"
      student_sally = FactoryGirl.create(:student_sally_user)
      User.stub(:find).with(student_sally.id).and_return(student_sally)
      Grade.give_grade(@course_fse.id, @assignment_1.id, student_sally.id, score).should be_false
    end

    it "should be able to update multiple grades" do
      grades = []
      [@assignment_1, @assignment_2].each do |assignment|
        grades << {:course_id=>@course_fse.id, :assignment_id => assignment.id, :student_id=>@student_sam.id, :score => "10" }
      end
      Grade.give_grades(grades)
      grades.each do |grade_entry|
        Grade.find_by_assignment_id_and_student_id(grade_entry[:assignment_id], grade_entry[:student_id]).score.should eq(grade_entry[:score])
      end
    end
  end

  context "final grade" do
    it "should be able to find final grades if they are given and are student visible" do
      final_grade = "A"
      Grade.give_grade(@course_fse.id, -1, @student_sam.id, final_grade, true)
      Grade.get_final_grade(@course_fse.id, @student_sam.id).should eql(final_grade)
    end

    it "should be not able to find final grades if they are given and are student invisible" do
      final_grade = "A"
      Grade.give_grade(@course_fse.id, -1, @student_sam.id, final_grade, false)
      Grade.get_final_grade(@course_fse.id, @student_sam.id).should eql("")
    end

    it "should be able to give final grades" do
      score = "A"
      Grade.give_grade(@course_fse.id, -1, @student_sam.id, score).should be_true
    end

    it "when given and are student visible, should not update other course grades" do
      Course.any_instance.stub(:update_distribution_list).and_return(true)
      @course_ise = FactoryGirl.create(:course_ise_with_students, registered_students: [@student_sam])
      @ise_grading_rule = FactoryGirl.build_stubbed(:grading_rule_points, :course_id => @course_ise.id)
      @course_ise.grading_rule.stub(:validate_score).and_return(true)

      fse_final_grade = "B+"
      ise_final_grade = "A-"
      Grade.give_grade(@course_fse.id, -1, @student_sam.id, fse_final_grade, true).should be_true
      Grade.give_grade(@course_ise.id, -1, @student_sam.id, ise_final_grade, true).should be_true
      Grade.get_final_grade(@course_fse.id, @student_sam.id).should eql(fse_final_grade)
      Grade.get_final_grade(@course_ise.id, @student_sam.id).should eql(ise_final_grade)

    end

  end

  # Beg Add Turing Ira

  context " It should save last graded by while giving grades" do

    it "should be able to give a updated grade to a registered student" do
      faculty_frank = FactoryGirl.build(:faculty_frank_user)
      faculty = faculty_frank.id
      score = "10"

      Grade.give_grade(@course_fse.id, @assignment_1.id, @student_sam.id, score,nil,faculty).should be_true
      Grade.find_by_assignment_id_and_student_id(@assignment_1.id, @student_sam.id).last_graded_by.should eq(faculty)
    end

    it "should not update faculty in last graded by when last graded by is not empty" do
      faculty_frank = FactoryGirl.build(:faculty_frank_user)
      faculty_fagan = FactoryGirl.build(:faculty_fagan_user)
      faculty = faculty_frank.id
      score = "10"
      score1 = "7"

      Grade.give_grade(@course_fse.id, @assignment_1.id, @student_sam.id, score,nil,faculty).should be_true
      Grade.give_grade(@course_fse.id, @assignment_1.id, @student_sam.id, score1,nil,faculty_fagan.id).should be_true

      Grade.find_by_assignment_id_and_student_id(@assignment_1.id, @student_sam.id).last_graded_by.should eq(faculty)
    end

    it "should be able to update multiple grades with last graded by in grade book" do
      faculty_frank = FactoryGirl.build(:faculty_frank_user)
      faculty = faculty_frank.id
      grades = []

      [@assignment_1, @assignment_2].each do |assignment|
        grades << {:course_id=>@course_fse.id, :assignment_id => assignment.id, :student_id=>@student_sam.id, :score => "10" }
      end

      Grade.give_grades(grades,faculty)
      grades.each do |grade_entry|
        Grade.find_by_assignment_id_and_student_id(grade_entry[:assignment_id], grade_entry[:student_id]).last_graded_by.should eq(faculty)
      end
    end

  end

# End Add Turing Ira
end
