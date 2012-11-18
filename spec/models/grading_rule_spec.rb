require 'spec_helper'

describe GradingRule do
  context "can convert grade" do
    before do
      @course_fse = FactoryGirl.create(:fse)
      @course_grading_rule = FactoryGirl.create(:grading_rule_points, :course_id=> @course_fse.id)
    end

    it "should be able to get points from letter"  do
      @course_grading_rule.convert_points_to_letter_grade(100).should eq("A")
      @course_grading_rule.convert_points_to_letter_grade(94).should eq("A")
      @course_grading_rule.convert_points_to_letter_grade(93.9).should eq("A-")
      @course_grading_rule.convert_points_to_letter_grade(90).should eq("A-")
      @course_grading_rule.convert_points_to_letter_grade(89.9).should eq("B+")
      @course_grading_rule.convert_points_to_letter_grade(87).should eq("B+")
      @course_grading_rule.convert_points_to_letter_grade(86.9).should eq("B")
      @course_grading_rule.convert_points_to_letter_grade(83).should eq("B")
      @course_grading_rule.convert_points_to_letter_grade(82.9).should eq("B-")
      @course_grading_rule.convert_points_to_letter_grade(80).should eq("B-")
      @course_grading_rule.convert_points_to_letter_grade(79.9).should eq("C+")
      @course_grading_rule.convert_points_to_letter_grade(78).should eq("C+")
      @course_grading_rule.convert_points_to_letter_grade(77.9).should eq("C")
      @course_grading_rule.convert_points_to_letter_grade(74).should eq("C")
      @course_grading_rule.convert_points_to_letter_grade(73.9).should eq("C-")
      @course_grading_rule.convert_points_to_letter_grade(70).should eq("C-")
    end

    it "should be able to get letter from points" do
      @course_grading_rule.convert_letter_grade_to_points("A").should eq(100)
      @course_grading_rule.convert_letter_grade_to_points("A-").should eq(93.9)
      @course_grading_rule.convert_letter_grade_to_points("B+").should eq(89.9)
      @course_grading_rule.convert_letter_grade_to_points("B").should eq(86.9)
      @course_grading_rule.convert_letter_grade_to_points("B-").should eq(82.9)
      @course_grading_rule.convert_letter_grade_to_points("C+").should eq(79.9)
      @course_grading_rule.convert_letter_grade_to_points("C").should eq(77.9)
      @course_grading_rule.convert_letter_grade_to_points("C-").should eq(73.9)
    end
  end

  context "using points" do
    before do
      @course_fse = FactoryGirl.create(:fse)
      @course_grading_rule = FactoryGirl.create(:grading_rule_points, :course_id=> @course_fse.id)
    end

    it "should be able to get grade in format" do
      GradingRule.get_grade_in_prof_format(@course_fse.id, 100).should eq(100)
    end
  end
end
