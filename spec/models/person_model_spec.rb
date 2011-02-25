require 'spec_helper'

describe Person do


  describe 'Custom Finders' do

    before do
      User.delete_all
      @admin_andy = Factory(:admin_andy)
      @student_sam = Factory(:student_sam)
      @faculty_frank = Factory(:faculty_frank)
    end

    it "should have a named scope staff" do
      subject.should respond_to(:staff)
    end

    it 'finds all staff' do
      Person.staff.should =~[:admin_andy, :faculty_frank]
    end

    it "should have a named scope teachers" do
      subject.should respond_to(:teachers)
    end

    it 'finds all teachers' do
      Person.staff.should =~[:faculty_frank]
    end

    
  end


  it "should allow for StrengthFinder/StrengthQuest themes" do
    subject.should respond_to(:strength1)
    subject.should respond_to(:strength2)
    subject.should respond_to(:strength3)
    subject.should respond_to(:strength4)
    subject.should respond_to(:strength5)

    user = Factory.build(:strength_quest)
    user.strength1.theme.should be_kind_of(String)
  end




end