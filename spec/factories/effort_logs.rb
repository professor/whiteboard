FactoryGirl.define do
factory :effort1, :parent => :effort_log do |e|
  e.week_number {(Date.today-7).cweek}
  e.year {(Date.today-7).cwyear}
  e.sum 24
end

factory :effort2, :parent => :effort_log do |e|
  e.week_number {(Date.today-7).cweek}
  e.year {(Date.today-7).cwyear}
  e.sum 6
end

factory :effort3, :parent => :effort_log do |e|
  e.week_number {(Date.today-7).cweek}
  e.year {(Date.today-7).cwyear}
  e.sum 12
end

end