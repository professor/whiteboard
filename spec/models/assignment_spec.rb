require 'spec_helper'

describe Assignment do
  before(:each) { @assignment = FactoryGirl.build(:assignment) }
  subject { @assignment }

  it 'should have a title' do
    subject.title = ""
    subject.should_not be_valid
    subject.errors[:title].should_not be_empty
  end

  it 'should have a valid max score' do
    subject.max_score = -1
    subject.should_not be_valid
    subject.errors[:max_score].should_not be_empty
  end

  it 'should have a valid weight' do
    subject.weight = -1
    subject.should_not be_valid
    subject.errors[:weight].should_not be_empty
  end

  context 'when the student can submit' do
    before(:each) { subject.can_submit = true }
    it 'should have a valid due date' do
      subject.due_date = DateTime.now
      subject.should_not be_valid
      subject.errors[:due_date].should_not be_empty
    end
  end
end
