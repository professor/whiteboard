require 'spec_helper'

describe ScottyDogSaying do


  it 'can be created' do
    lambda {
      FactoryGirl.create(:scotty_dog_saying)
    }.should change(ScottyDogSaying, :count).by(1)
  end

 context "is not valid" do

    [:saying, :user_id].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end

  context "is editable" do
    before(:each) do
      @admin_andy = FactoryGirl.create(:admin_andy)
      @faculty_frank = FactoryGirl.create(:faculty_frank)
      @student_sam = FactoryGirl.create(:student_sam)
      @saying = FactoryGirl.create(:scotty_dog_saying, :user => @student_sam)
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