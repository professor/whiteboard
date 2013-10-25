class EffortLogLineItem < ActiveRecord::Base
  acts_as_list :scope => :effort_log

  belongs_to :effort_log
  belongs_to :task_type
  belongs_to :course

#    before_save :determine_total_effort #this is not necessary since it is also called by the effort_log before a save
  validates_numericality_of :day1, :day2, :day3, :day4, :day5, :day6, :day7, :greater_than_or_equal_to => 0, :allow_nil => true

  def determine_total_effort
    self.sum = 0
    self.sum = self.sum + self.day1 if !self.day1.nil?
    self.sum = self.sum + self.day2 if !self.day2.nil?
    self.sum = self.sum + self.day3 if !self.day3.nil?
    self.sum = self.sum + self.day4 if !self.day4.nil?
    self.sum = self.sum + self.day5 if !self.day5.nil?
    self.sum = self.sum + self.day6 if !self.day6.nil?
    self.sum = self.sum + self.day7 if !self.day7.nil?
  end
end
