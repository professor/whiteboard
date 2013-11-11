require 'factory_girl'

FactoryGirl.define do

  factory :prof, :parent => :person do
    is_staff 1
  end

  factory :prof_liu, :parent => :prof do
    first_name "YC"
    last_name "Liu"
    human_name "YC Liu"
    twiki_name "KateLiu"
    email "kate.liu@sv.cmu.edu"
  end

  factory :prof_singh, :parent => :prof do
    first_name "P"
    last_name "Singh"
    human_name "P Singh"
    twiki_name "PrabhjotSingh"
    email "prabhjot.singh@sv.cmu.edu"
  end

  factory :prof_lee, :parent => :prof do
    first_name "TY"
    last_name "Lee"
    human_name "TY Lee"
    twiki_name "LydianLee"
    email "lydian.lee@sv.cmu.edu"
  end

  factory :prof_evans, :parent => :prof do
    first_name "Stuart"
    last_name "Evans"
    human_name "Stuart Evans"
    twiki_name "StuartEvans"
    email "stuart.evans@sv.cmu.edu"
  end

  factory :prof_peraire, :parent => :prof do
    first_name "Cecile"
    last_name "Peraire"
    human_name "Cecile Peraire"
    twiki_name "CecilePeraire"
    email "cecile.peraire@sv.cmu.edu"
  end

  factory :prof_zhang, :parent => :prof do
    first_name "Jia"
    last_name "Zhang"
    human_name "Jia Zhang"
    twiki_name "JiaZhang"
    email "jia.zhang@sv.cmu.edu"
  end

  factory :prof_snape, :parent => :prof do
    first_name "Snape"
    last_name "Snape"
    human_name "Severus Snape"
    twiki_name "SeverusSnape"
    email "severus.snape@sv.cmu.edu"
  end

end
