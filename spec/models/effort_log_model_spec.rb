require 'spec_helper'

describe EffortLog do

  context 'log_effort_week?' do
    it 'should respond to log_effort_week?' do
      EffortLog.should respond_to :log_effort_week?
    end

    it 'it is spring break' do
      EffortLog.log_effort_week?(2010, 9).should == false
      EffortLog.log_effort_week?(2010, 10).should == false
    end

    it 'it is not spring break' do
      (1..8).each do |week_number|
        EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
      end
      (11..52).each do |week_number|
        EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
      end
    end

  end


end
