require 'spec_helper'

describe Deliverable do

  before(:all) do
      activate_authlogic
  end

  it 'can be created' do
    lambda {
      Factory(:deliverable)
    }.should change(Deliverable, :count).by(1)
  end

  context "is not valid" do

    [:course, :creator].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end

  it "should return team name for a team deliverable" do
    deliverable = Factory.build(:team_deliverable)
    deliverable.stub(:update_team)
    deliverable.save
    deliverable.owner_name.should be_equal(deliverable.team.name)
  end

    it "should return person name for a individual deliverable" do
    deliverable = Factory(:individual_deliverable)
    deliverable.owner_name.should be_equal(deliverable.creator.human_name)
  end

  it "should return team email for a team deliverable" do
    deliverable = Factory.build(:team_deliverable)
    deliverable.stub(:update_team)
    deliverable.save
    deliverable.owner_email.should be_equal(deliverable.team.email)
  end

  it "should return person email for a individual deliverable" do
    deliverable = Factory(:individual_deliverable)
    deliverable.owner_email.should be_equal(deliverable.creator.email)
  end

  context "has_feeback?" do
  it "returns false when there is no feedback" do
    subject.has_feedback?.should be_false

#!(self.feedback_comment.nil? or self.feedback_comment == "") or !self.feedback_file_name.nil?
  end

  it "returns true when there is a comment" do
    subject.feedback_comment = "Great job team!"
    subject.has_feedback?.should be_true
  end

  it "returns true when there is a file" do
    subject.feedback_file_name = "/somewhere_on_s3/somewhere_over_the_rainbow/amazing_feedback.txt"
    subject.has_feedback?.should be_true
  end


  end



end


