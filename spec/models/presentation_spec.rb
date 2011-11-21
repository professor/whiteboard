require 'spec_helper'

describe Presentation do
  def valid_attributes
    {:name => "Test Project",
     :creator => Factory(:faculty_frank),
     :presentation_file_name => "Testfilename.ppt"
      }
  end

  [:name, :creator, :presentation_file_name].each do |attr|
    it "should not be valid without a #{attr.to_s}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_nil
    end
  end

  it "should not be valid without team_id OR user_id" do
    subject.should_not be_valid
    subject.errors[:team_id].should_not be_nil
  end

  it "should not be valid with both team_id and user_id" do
    subject.attributes = valid_attributes
    subject.user_id = 1
    subject.team_id = 1
    subject.should_not be_valid
    subject.errors[:team_id].should_not be_nil
  end

  it "should be valid with only user_id" do
    subject.attributes = valid_attributes
    subject.user_id = 1
    subject.should be_valid
    subject.errors[:team_id].should be_empty
  end

  it "should be valid with only team_id" do
    subject.attributes = valid_attributes
    subject.team_id = 1
    subject.should be_valid
    subject.errors[:team_id].should be_empty
  end
end
