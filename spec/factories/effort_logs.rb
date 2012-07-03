FactoryGirl.define do
  factory :effort1, :parent => :effort_log do
    week_number { (Date.today-7).cweek }
    year { (Date.today-7).cwyear }
    sum 24
  end

  factory :effort2, :parent => :effort_log do
    week_number { (Date.today-7).cweek }
    year { (Date.today-7).cwyear }
    sum 6
  end

  factory :effort3, :parent => :effort_log do
    week_number { (Date.today-7).cweek }
    year { (Date.today-7).cwyear }
    sum 12
  end

end