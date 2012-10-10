require 'spec_helper'

describe Assignment do
  pending "add some examples to (or delete) #{__FILE__}"

  context "validate assignments" do
    [:maximum_score, :course_id,:task_number].each do  |attr|
        it "without #{attr} not valid" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
    end
  end
end
