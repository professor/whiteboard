require 'spec_helper'

describe GradingRule do
  before do
    @course_fse = FactoryGirl.create(:fse)
  end

  context "using points" do
    before do
      @course_grading_rule = FactoryGirl.create(:grading_rule_points, :course_id=> @course_fse.id)
      @course_fse.grading_rule = @course_grading_rule
      @assignment = FactoryGirl.create(:assignment_fse)
      @course_fse.assignments << @assignment
    end

    it "should be able to validate scores format" do
      @course_grading_rule.validate_score("2.0").should be_true
    end

    it "should validate letter grades" do
      @course_grading_rule.validate_letter_grade("A")
    end

    it "should maintain the hash " do
      letter_grades = ["A", "R", "W", "I", "A-", "B+", "B", "B-", "C+", "C", "C-"]
      @course_grading_rule.letter_grades.should eql(letter_grades)
    end

    it "should be able to tell the users about the grade type" do
      GradingRule.get_grade_type(@course_fse.id).should eql("points")
    end
  end

  context "using weights" do
    before do
      @course_grading_rule = FactoryGirl.create(:grading_rule_weights, :course_id=> @course_fse.id)
      @course_fse.grading_rule = @course_grading_rule
    end

    it "should be able to validate scores format" do
      @course_grading_rule.validate_score("20").should be_true
      @course_grading_rule.validate_score("20%").should be_true
    end
    
    it "should be able to format scores" do
      GradingRule.format_score(@course_fse.id, "20%").should eq("20")
    end
  end

end

