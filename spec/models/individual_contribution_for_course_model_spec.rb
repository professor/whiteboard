require 'spec_helper'

describe IndividualContributionForCourse do



  # named scope
  # default sorting order
  # foreign associations with user, year, week_number
 
    it 'can be created' do
      lambda {
        Factory(:individual_contribution_for_course)
      }.should change(IndividualContributionForCourse, :count).by(1)
    end
  
    context "is not valid" do
  
      [:individual_contribution_id, :course_id].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end
  
    end

  
    context "associations --" do
      it 'belongs to individual_contribution' do
        subject.should respond_to(:individual_contribution)
      end
  
    end
end
