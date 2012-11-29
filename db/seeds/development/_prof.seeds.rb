require 'factory_girl'

FactoryGirl.define do

  factory :prof, :parent => :person do
    is_staff 1
  end

  factory :prof_liu, :parent => :prof do
    first_name "YC"
    last_name "Liu"
    human_name "YC Liu"
    email "kate.liu@sv.cmu.edu"
  end

  factory :prof_singh, :parent => :prof do
    first_name "P"
    last_name "Singh"
    human_name "P Singh"
    email "prabhjot.singh@sv.cmu.edu"
  end

  factory :prof_lee, :parent => :prof do
    first_name "TY"
    last_name "Lee"
    human_name "TY Lee"
    email "lydian.lee@sv.cmu.edu"
  end

  factory :prof_evans, :parent => :prof do
    first_name "Stuart"
    last_name "Evans"
    human_name "Stuart Evans"
    email "stuart.evans@sv.cmu.edu"
  end

  factory :prof_peraire, :parent => :prof do
    first_name "Cecile"
    last_name "Peraire"
    human_name "Cecile Peraire"
    email "cecile.peraire@sv.cmu.edu"
  end

end
