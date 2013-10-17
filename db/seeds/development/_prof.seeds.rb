require 'factory_girl'

FactoryGirl.define do

  factory :prof, :parent => :person do
    is_staff 1
  end

  factory :prof_liu, :parent => :prof do
    first_name "Todd"
    last_name "Sedano"
    human_name "Todd Sedano"
    email "Todd.Sedano@sv.cmu.edu"
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
    email "Tylian.lee@sv.cmu.edu"
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

  factory :prof_zhang, :parent => :prof do
    first_name "Jia"
    last_name "Zhang"
    human_name "Jia Zhang"
    email "jia.zhang@sv.cmu.edu"
  end

  factory :prof_snape, :parent => :prof do
    first_name "Severus"
    last_name "Snape"
    human_name "Severus Snape"
    email "severus.snape@sv.cmu.edu"
  end

  factory :prof_snape, :parent => :prof do
    first_name "Gladys"
    last_name "Mercier"
    human_name "Gladys Mercier"
    email "gladys.mercier@sv.cmu.edu"
  end
end
