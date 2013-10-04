require 'spec_helper'

describe PeerEvaluationLearningObjective do

  it 'can be created' do
    lambda {
      FactoryGirl.create(:peer_evaluation_learning_objective)
    }.should change(PeerEvaluationLearningObjective, :count).by(1)
  end

end