require 'spec_helper'

describe GradeBook do
  before(:all) do
    @student_sam = FactoryGirl.build(:student_sam_user)
    @course_fse = FactoryGirl.build(:course_fse_with_students, registered_students: [@student_sam])
    @assignment_fse = FactoryGirl.build(:assignment_fse)
    @grade_book = GradeBook.new(course: @course_fse, student: @student_sam, assignment: @assignment_fse)
    #subject {GradeBook.new(course: @course_fse, student: @student_sam)}
  end

  it "should belong to a course" do
    @grade_book.course.should == @course_fse
  end

  it "should belong to a student" do
    @grade_book.student.should == @student_sam
  end

  it "should belong to an assignment" do
    @grade_book.assignment.should == @assignment_fse
  end

  #its (:course) { should == @course_fse }
  #its (:student) {should == @student_sam}
  #its (:assignment) {should == @assignment_fse}

  #grade_book.scores  => {:assignment1=>1, :assignment2=>2 }
  it "can get all students score"

  #grade_book.get_score(:assignment)
  it "can get a student's specific assignment score"

  #grade_book.student.name
  it "can get a single student name"


  #grade_book.get_score(:student) => {:course =>{:assignment1 =>1 ,...}}
  it "can get a student's all score"

  #grade_book.course.teams
  it "can get all teams in a course"

  # grade_book.student.team
  it "can get a student team"

  # grade_book.final_score
  it "can get a student final score"

  it "can get task number"
  it "can get assignment name"
  it "can get assignment score "
  it "can get final score"






end
