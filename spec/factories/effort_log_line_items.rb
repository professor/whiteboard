require File.join(Rails.root,'spec','factories','factories.rb')
Factory.define :elli_line1, :parent => :effort_log_line_item do |e|
  e.day1 0
  e.day2 20
  e.day3 2
  e.day4 2
  e.day5 0
  e.day6 0
  e.day7 0
  e.sum 24
end


Factory.define :elli_line2, :parent => :effort_log_line_item do |e|
  e.day1 1
  e.day2 1
  e.day3 1
  e.day4 1
  e.day5 1
  e.day6 1
  e.day7 0
  e.sum 6
end

Factory.define :elli_line3, :parent => :effort_log_line_item do |e|
  e.day1 2
  e.day2 2
  e.day3 2
  e.day4 2
  e.day5 2
  e.day6 1
  e.day7 1
  e.sum 12
end