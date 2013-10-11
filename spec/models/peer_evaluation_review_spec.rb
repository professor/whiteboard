require 'spec_helper'

describe PeerEvaluationReview do

  it 'is_completed_for? returns true for people who have done it' do
    review = FactoryGirl.create(:peer_evaluation_review)
    PeerEvaluationReview.is_completed_for?(review.author_id, review.team.id).should be_true
  end

  it 'is_completed_for? returns false for people who have not done it' do
    PeerEvaluationReview.is_completed_for?(nil, nil).should be_false
  end

  describe "is protected against mass assignment" do
    it { should_not allow_mass_assignment_of(:team_id) }
    it { should_not allow_mass_assignment_of(:author_id) }
    it { should_not allow_mass_assignment_of(:recipient_id) }
    it { should_not allow_mass_assignment_of(:question) }
    it { should_not allow_mass_assignment_of(:sequence_number) }
  end
end

