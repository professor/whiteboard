require 'spec_helper'

#
# Note: to check future dates, use the following code. Date.new(2010, 8, 23).cweek
#
  

describe AcademicCalendar do

  context 'current semester' do
    it 'should respond to current_semester' do
      AcademicCalendar.should respond_to :current_semester
    end

    it 'should return Fall in the Fall' do
       Date.stub!(:today).and_return(Date.new(2010, 9, 1))
       AcademicCalendar.current_semester.should == "Fall"
    end
    it 'should return Spring in the Spring' do
       Date.stub!(:today).and_return(Date.new(2011, 3, 1))
       AcademicCalendar.current_semester.should == "Spring"
    end
    it 'should return Summer in the Summer' do
       Date.stub!(:today).and_return(Date.new(2011, 7, 1))
       AcademicCalendar.current_semester.should == "Summer"
    end
  end

  context 'next semester' do
    it 'should respond to next_semester' do
      AcademicCalendar.should respond_to :next_semester
    end

    it 'should return Spring in the Fall' do
       Date.stub!(:today).and_return(Date.new(2010, 9, 1))
       AcademicCalendar.next_semester.should == "Spring"
    end
    it 'should return Summer in the Spring' do
       Date.stub!(:today).and_return(Date.new(2011, 3, 1))
       AcademicCalendar.next_semester.should == "Summer"
    end
    it 'should return Fall in the Summer' do
       Date.stub!(:today).and_return(Date.new(2011, 7, 1))
       AcademicCalendar.next_semester.should == "Fall"
    end
  end

  context 'next semester year' do
    it 'should respond to next_semester year' do
      AcademicCalendar.should respond_to :next_semester_year
    end

    it 'should return year+1 in the Fall' do
       Date.stub!(:today).and_return(Date.new(2010, 9, 1))
       AcademicCalendar.next_semester_year.should == 2011
    end
    it 'should return year in the Spring' do
       Date.stub!(:today).and_return(Date.new(2011, 3, 1))
       AcademicCalendar.next_semester_year.should == 2011
    end
    it 'should return year in the Summer' do
       Date.stub!(:today).and_return(Date.new(2011, 7, 1))
       AcademicCalendar.next_semester_year.should == 2011
    end
  end

  context 'next semester is soon' do
    it 'should respond to next semester is soon' do
      AcademicCalendar.should respond_to :next_semester_is_soon
    end

    it 'should return false when we are in Mini A' do
     year = Date.today.year
     ["Fall", "Spring", "Summer"].each do |semester|
       Date.stub!(:today).and_return(Date.commercial(year, AcademicCalendar.semester_start(semester, year)))
       AcademicCalendar.next_semester_is_soon.should == false
     end
    end

    it 'otherwise return true' do
      Date.stub!(:today).and_return(Date.new(2011, 3, 14))
      AcademicCalendar.next_semester_is_soon.should == true
    end

    it 'should return false during Mini A, otherwise return true' do
      year = Date.today.year
      (1..52).each do |cweek|
        Date.stub!(:today).and_return(Date.commercial(year, cweek))
        AcademicCalendar.current_mini == "A" ? AcademicCalendar.next_semester_is_soon.should == false : AcademicCalendar.next_semester_is_soon.should == true
      end
    end


  end

  context 'determine if a particular week is in a semester' do
    it 'should respond to semester_start' do
      AcademicCalendar.should respond_to :week_during_semester?
    end

    it 'weeks before semester start are not in' do
      year = Date.today.cwyear
      AcademicCalendar.week_during_semester?(year, AcademicCalendar.semester_start("Fall", year) - 1).should == false
      AcademicCalendar.week_during_semester?(year, AcademicCalendar.semester_start("Spring", year) - 1).should == false
      AcademicCalendar.week_during_semester?(year, AcademicCalendar.semester_start("Summer", year) - 1).should == false
    end

    it 'weeks starting a semester are in' do
      year = Date.today.cwyear
      AcademicCalendar.week_during_semester?(year, AcademicCalendar.semester_start("Fall", year)).should == true
      AcademicCalendar.week_during_semester?(year, AcademicCalendar.semester_start("Spring", year)).should == true
      AcademicCalendar.week_during_semester?(year, AcademicCalendar.semester_start("Summer", year)).should == true
    end
  end

  it 'should determine which Semester Mini it is' do
    Date.stub!(:today).and_return(Date.new(2011, 1, 10)) #Also Date.commercial(year, week_number) works
    AcademicCalendar.current_mini.should == "A"

    Date.stub!(:today).and_return(Date.new(2011, 3, 14))
    AcademicCalendar.current_mini.should == "B"

    Date.stub!(:today).and_return(Date.new(2011, 5, 16))
    AcademicCalendar.current_mini.should == "A"

    Date.stub!(:today).and_return(Date.new(2011, 6, 27))
    AcademicCalendar.current_mini.should == "B"

    Date.stub!(:today).and_return(Date.new(2011, 8, 29))
    AcademicCalendar.current_mini.should == "A"

    Date.stub!(:today).and_return(Date.new(2011, 10, 17))
    AcademicCalendar.current_mini.should == "B"
  end


  context 'spring_break' do
    it 'should respond to spring_break' do
      AcademicCalendar.should respond_to :spring_break
    end

    it 'should warn the site administrator when the calendar is not current and needs updating' do
      mailer = double("mailer")
      mailer.stub(:deliver)
      GenericMailer.should_receive(:email).and_return(mailer)
      AcademicCalendar.spring_break(1900).should == nil
    end

    it 'it is spring break' do
      AcademicCalendar.spring_break(2010) == (9..10)
    end
  end

  context 'semester start' do
    it 'should respond to semester_start' do
      AcademicCalendar.should respond_to :semester_start
    end

    it 'should warn the site administrator when the calendar is not current and needs updating' do
      mailer = double("mailer")
      mailer.stub(:deliver)
      GenericMailer.should_receive(:email).and_return(mailer)
      AcademicCalendar.semester_start("Fall", 1900).should == nil
    end


    it 'should know the academic year 2011-2012' do
      AcademicCalendar.semester_start("Fall", 2011).should == 35
#      AcademicCalendar.semester_start("Spring", 2012).should == 2
#      AcademicCalendar.semester_start("Summer", 2012).should == 20
    end

    it 'should know the academic year 2010-2011' do
      AcademicCalendar.semester_start("Fall", 2010).should == 34
      AcademicCalendar.semester_start("Spring", 2011).should == 2
      AcademicCalendar.semester_start("Summer", 2011).should == 20
    end


  # For the academic year 2008-2009, here are the start dates of each semester
  # Fall, 8/25/08 which is cweek 35, (Orientation is 34)
  # Spring, 1/12/09 which is cweek 3, (Gathering is 2)
  # Summer, 5/18/09 which is cweek 21, (Gathering is 20)
    it 'should know the academic year 2008-2009' do
      AcademicCalendar.semester_start("Fall", 2008).should == 35
      AcademicCalendar.semester_start("Spring", 2009).should == 3
      AcademicCalendar.semester_start("Summer", 2009).should == 21
    end

  #
  # For the academic year 2009-2010, here are the start dates of each semester
  # Fall, 8/24/09 which is cweek 34, (Orienation is 33)
  # Spring, 1/11/10 which is cweek 2, (Gathering is 1)
  # Summer, 5/17/10 which is cweek 20, (Gathering is 19)
    it 'should know the academic year 2009-2010' do
      AcademicCalendar.semester_start("Fall", 2009).should == 34
      AcademicCalendar.semester_start("Spring", 2010).should == 2
      AcademicCalendar.semester_start("Summer", 2010).should == 20
    end


  end



end