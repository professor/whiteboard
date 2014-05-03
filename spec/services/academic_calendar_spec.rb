require 'spec_helper'
require_relative '../../app/services/academic_calendar.rb'

describe AcademicCalendar do

  context "Academic Calendar" do

    it 'should return spring break range' do
      AcademicCalendar.spring_break(2014).should eq(10..11)
    end

    it 'should return term lengths' do
      AcademicCalendar.term_length("Fall", "A").should eq(7)
      AcademicCalendar.term_length("Fall", "B").should eq(7)
      AcademicCalendar.term_length("Fall", "Both").should eq(15)

      AcademicCalendar.term_length("Spring", "A").should eq(7)
      AcademicCalendar.term_length("Spring", "B").should eq(7)
      AcademicCalendar.term_length("Spring", "Both").should eq(16)

      AcademicCalendar.term_length("Summer", "A").should eq(6)
      AcademicCalendar.term_length("Summer", "B").should eq(6)
      AcademicCalendar.term_length("Summer", "Both").should eq(12)
    end

    it 'should return due date for grades' do
      AcademicCalendar.grades_due_for("Spring", 2014).should eq(Date.new(2014, 5, 21))
    end

  end

end
