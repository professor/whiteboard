FactoryGirl.define do

factory :team_triumphant, :parent => :team do |t|
 t.name "Team Triumphant"
 t.email "triumphant@sv.cmu.edu"
 t.tigris_space "http://triumphant.tigris.org/servlets/ProjectDocumentList"
 t.twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
 t.updating_email false
 t.association :course, :factory => :course
 t.after_create { |t| FactoryGirl.create(:student_sam, :teams => [t], :login => "student_sam_random", :webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu")}
# t.after(:create) { |team| FactoryGirl.create(:student_sam, :teams => [team], :login => "student_sam_random", :webiso_account => Time.now.to_f.to_s + "@andrew.cmu.edu")}
end

  end