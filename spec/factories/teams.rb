FactoryGirl.define do

  factory :team_triumphant, :parent => :team do
    name "Team Triumphant"
    email "triumphant@sv.cmu.edu"
    tigris_space "http://triumphantigris.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    updating_email false
    association :course, :factory => :course
#    after(:create) { |team| FactoryGirl.create(:student_sam, :teams => [team], :webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
#    after(:create) { |team| FactoryGirl.create(:student_sam_user, :teams => [team], :webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
    after(:create) { |team| FactoryGirl.create(:student_sam_user, :webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
  end

  # factories added by team maverick
  factory :team_maverick, :parent => :team do
    name "Team Maverick"
    email "team.maverick@sv.cmu.edu"
    updating_email false
    association :course, :factory => :course
    #webiso_account "team.maverick@andrew.cmu.edu"
    #after(:create) { |team| FactoryGirl.create(:webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
  end

  factory :team_amigos, :parent => :team do
    name "Team Amigos"
    email "team.amigos@sv.cmu.edu"
    updating_email false
    association :course, :factory => :course
    #webiso_account "team.amigos@andrew.cmu.edu"
    after(:create) { |team| FactoryGirl.create(:webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
  end

  factory :team_cooper, :parent => :team do
    name "Team Cooper"
    email "team.cooper@sv.cmu.edu"
    updating_email false
    association :course, :factory => :course
    #webiso_account "team.cooper@andrew.cmu.edu"
    #after(:create) { |team| FactoryGirl.create(:webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
  end

  factory :team_leffingwell, :parent => :team do
    name "Team Leffingwell"
    email "team.leffingwell@sv.cmu.edu"
    updating_email false
    association :course, :factory => :course
    #webiso_account "team.leffingwell@andrew.cmu.edu"
    after(:create) { |team| FactoryGirl.create(:webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu") }
  end

end