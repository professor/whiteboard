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

  factory :team_bean_counters, class: Team do
    name "Bean Counters"
    email "bean_counters@sv.cmu.edu"
    tigris_space "http://team.tigris.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    members { |members| [members.association(:student_sally)] }
    association :course, :factory => :course
  end

end