require 'spec_helper'

describe Suggestion do

  it 'can be created' do
    lambda {
      Factory(:suggestion)
    }.should change(Suggestion, :count).by(1)
  end

 context "is not valid" do

    [:comment].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end

  context "is editable" do
    before(:each) do
      @admin_andy = Factory(:admin_andy)
      @faculty_frank = Factory(:faculty_frank)
      @student_sam = Factory(:student_sam)
      @saying = Factory(:suggestion, :user => @student_sam)
    end


    it "by an admin" do
      @saying.should be_editable(@admin_andy)
    end

    it "by the author" do
      @saying.should be_editable(@student_sam)
    end

    it "but not by anyone else" do
      @saying.should_not be_editable(@faculty_frank)
    end

  end

end