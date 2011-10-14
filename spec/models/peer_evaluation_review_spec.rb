require 'spec_helper'

describe PeerEvaluationReview do

  it 'is_completed_for? returns true for people who have done it' do
    review = Factory(:peer_evaluation_review)
    PeerEvaluationReview.is_completed_for?(review.author_id, review.team.id).should be_true
  end

  it 'is_completed_for? returns false for people who have not done it' do
    PeerEvaluationReview.is_completed_for?(nil, nil).should be_false
  end


end

