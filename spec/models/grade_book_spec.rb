require 'spec_helper'

describe GradeBook do
  before(:each) do
    @student_sam = FactoryGirl.create(:student_sam_user)
    @course_fse = FactoryGirl.create(:course_fse_with_students, registered_students: [@student_sam])
    @assignment_fse = FactoryGirl.create(:assignment_fse)
    @grade_book = GradeBook.create(:course_id => @course_fse.id, 
                                   :student_id => @student_sam.id, 
                                   :assignment_id => @assignment_fse.id,
                                   :score => 0)
  end

  after(:each) do
    @student_sam.delete
    @course_fse.delete
    @assignment_fse.delete
    @grade_book.delete
  end

  subject { @grade_book }

  context "course_id" do
    its (:course_id) { should == @course_fse.id }
    
    it "should not be nil" do
      subject.course_id = nil
      subject.should_not be_valid
    end

    it "should not be blank" do
      subject.course_id = ""
      subject.should_not be_valid
    end
  end
  
  context "student_id" do
    its (:student_id) {should == @student_sam.id}

    it "should not be nil" do
      subject.student_id = nil
      subject.should_not be_valid
    end

    it "should not be blank" do
      subject.student_id = ""
      subject.should_not be_valid
    end
  end

  context "assignment_id" do
    its (:assignment_id) {should == @assignment_fse.id}
    
    it "should not be nil" do
      subject.assignment_id = nil
      subject.should_not be_valid
    end

    it "should not be blank" do
      subject.assignment_id = ""
      subject.should_not be_valid
    end
  end

  context "score" do
    it "should not be string" do
      subject.score = "just4test" 
      subject.should_not be_valid
    end  

    it 'should not be negative' do
      subject.score = -1.0 
      subject.should_not be_valid
    end
  end

  it 'should not be redundant' do
    redundant_grade_book = GradeBook.new(
      :course_id => @course_fse.id, 
      :student_id => @student_sam.id, 
      :assignment_id => @assignment_fse.id,
      :score => 0)
    redundant_grade_book.should_not be_valid
  end
end
