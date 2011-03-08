require 'spec_helper'

describe Person do


  describe 'Custom Finders' do

    before do
      User.delete_all
      # this list must not be sorted alphabetically
      @faculty_frank = Factory(:faculty_frank)
      @faculty_fagan = Factory(:faculty_fagan)
      @admin_andy = Factory(:admin_andy)
      @student_sam = Factory(:student_sam)
    end

    it "should have a named scope staff" do
      Person.should respond_to(:staff)
    end

    it 'finds all staff' do
      #Person.staff.should =~ [@admin_andy, @faculty_frank]
      staff = Person.staff
      staff.length.should == 3
      staff.include?(@admin_andy).should be_true
      staff.include?(@faculty_fagan).should be_true
      staff.include?(@faculty_frank).should be_true
    end

    it 'ordered by human name' do
      staff = Person.staff
      staff[0].should == @admin_andy
      staff[1].should == @faculty_fagan
      staff[2].should == @faculty_frank
    end

    it "should have a named scope teachers" do
      Person.should respond_to(:teachers)
    end

    it 'finds all teachers' do
      #Person.staff.should =~ [@faculty_frank]
      teachers = Person.teachers
      teachers.length.should == 2
      teachers.include?(@faculty_fagan).should be_true
      teachers.include?(@faculty_frank).should be_true
    end

    it 'ordered by human name' do
      teachers = Person.teachers
      teachers[0].should == @faculty_fagan
      teachers[1].should == @faculty_frank
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