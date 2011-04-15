require 'spec_helper'

describe Deliverable do

  it 'can be created' do
    lambda {
      Factory(:deliverable)
    }.should change(Deliverable, :count).by(1)
  end

  context "is not valid" do

    [:course, :creator_id].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end

end


