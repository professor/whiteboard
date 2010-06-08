class TestEffortLog < ActiveRecord::Migration
  def self.up
    @log2008_24 = EffortLog.create :person_id => 1, :week_number => 24, :year => 2008
    @log2008_25 = EffortLog.create :person_id => 1, :week_number => 25, :year => 2008
    @log2008_26 = EffortLog.create :person_id => 1, :week_number => 26, :year => 2008
    
#    EffortLogLineItem.create :effort_log_id => @log2008_25.id, @course_id => 1, :task_type_id => 1
#    EffortLogLineItem.create :effort_log_id => @log2008_25.id, @course_id => 1, :task_type_id => 2
#    EffortLogLineItem.create :effort_log_id => @log2008_25.id, @course_id => 1, :task_type_id => 3
#    EffortLogLineItem.create :effort_log_id => @log2008_25.id, @course_id => 1, :task_type_id => 4
#    EffortLogLineItem.create :effort_log_id => @log2008_26.id, @course_id => 1, :task_type_id => 1
#    EffortLogLineItem.create :effort_log_id => @log2008_26.id, @course_id => 1, :task_type_id => 2
#    EffortLogLineItem.create :effort_log_id => @log2008_26.id, @course_id => 1, :task_type_id => 3
#    EffortLogLineItem.create :effort_log_id => @log2008_26.id, @course_id => 1, :task_type_id => 4
    
    
  end

  def self.down
  end
end
