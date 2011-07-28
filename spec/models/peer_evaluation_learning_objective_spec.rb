require 'spec_helper'

describe PeerEvaluationLearningObjective do

  it 'can be created' do
    lambda {
      Factory(:peer_evaluation_learning_objective)
    }.should change(PeerEvaluationLearningObjective, :count).by(1)
  end

 context "is not valid" do

    # we now allow nil as a valid value
    # [:learning_objective].each do |attr|
    #   it "without #{attr}" do
    #     subject.should_not be_valid
    #     subject.errors[attr].should_not be_empty
    #   end
    # end
  
    it 'with a learning objective longer than 255 characters' do
      pelo = Factory.build(:peer_evaluation_learning_objective)
      new_learning_objective = ""
      256.times do |i|
        new_learning_objective += "1"
      end
      pelo.learning_objective = new_learning_objective
      pelo.save
      pelo.should_not be_valid
      pelo.errors[:learning_objective].should_not be_empty
    end
  end
end