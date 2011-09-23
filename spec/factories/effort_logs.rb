# require File.join(Rails.root,'spec','factories','factories.rb')
today = Date.today
monday_of_this_week = Date.commercial(today.year, today.cweek, 1)
Factory.define :effort_log, :class => EffortLog do |e|
  # REMOVE
  #e.year {(Date.today-3).year}
  #e.week_number {(Date.today-3).cweek}
  e.year monday_of_this_week.cwyear
  e.week_number monday_of_this_week.cweek
  e.association :person, :factory => :student_sam
end

Factory.define :effort1, :parent => :effort_log do |e|
  e.week_number {(Date.today-7).cweek}
  e.year {(Date.today-7).cwyear}
  e.sum 24
end

Factory.define :effort2, :parent => :effort_log do |e|
  e.week_number {(Date.today-7).cweek}
  e.year {(Date.today-7).cwyear}
  e.sum 6
end

Factory.define :effort3, :parent => :effort_log do |e|
  e.week_number {(Date.today-7).cweek}
  e.year {(Date.today-7).cwyear}
  e.sum 12
end

