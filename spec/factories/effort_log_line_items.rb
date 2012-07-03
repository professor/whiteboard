FactoryGirl.define do

  factory :elli_line1, :parent => :effort_log_line_item do
    day1 0
    day2 20
    day3 2
    day4 2
    day5 0
    day6 0
    day7 0
    sum 24
  end


  factory :elli_line2, :parent => :effort_log_line_item do
    day1 1
    day2 1
    day3 1
    day4 1
    day5 1
    day6 1
    day7 0
    sum 6
  end

  factory :elli_line3, :parent => :effort_log_line_item do
    day1 2
    day2 2
    day3 2
    day4 2
    day5 2
    day6 1
    day7 1
    sum 12
  end

end