require 'spec_helper'

describe GradingRule do

  context "using points" do
    before do
      @course_fse = FactoryGirl.create(:fse)
      @course_grading_rule = FactoryGirl.create(:grading_rule_points, :course_id=> @course_fse.id)
      @course_fse.grading_rule = @course_grading_rule
    end

    it "shoule be able to validate scores format" do
      @course_grading_rule.validate_score("2.0").should be_true
    end
  end

  context "using weights" do
    before do
      @course_fse = FactoryGirl.create(:fse)
      @course_grading_rule = FactoryGirl.create(:grading_rule_weights, :course_id=> @course_fse.id)
      @course_fse.grading_rule = @course_grading_rule
    end

    it "shoule be able to validate scores format" do
      @course_grading_rule.validate_score("20").should be_true
      @course_grading_rule.validate_score("20%").should be_true
    end
    
    it "shoule be able to format scores" do
      GradingRule.format_score(@course_fse.id, "20%").should eq("20")
    end
  end
end
