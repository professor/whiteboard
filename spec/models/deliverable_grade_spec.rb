require 'spec_helper'

describe DeliverableGrade do
  context "deliverable grade fields" do
    before {
      @student = FactoryGirl.create(:student_sally)
      @assignment = FactoryGirl.create(:assignment, weight: 20)
      @deliverable = FactoryGirl.create(:deliverable, creator: @student)
      @deliverable_grade = FactoryGirl.build(:deliverable_grade, deliverable: @deliverable, user: @student)
    }

    it "should save" do
      @deliverable_grade.grade = @assignment.weight - 1
      expect { @deliverable_grade.save }.to change(DeliverableGrade, :count).by(1)
    end

    it "should not save when grade is less than 0" do
      @deliverable_grade.grade = -1
      expect { @deliverable_grade.save }.to_not change(DeliverableGrade, :count)
      @deliverable_grade.errors.should include(:grade)
    end
  end
end