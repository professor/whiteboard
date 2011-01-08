Factory.define :team_triumphant, :class => Team do |t|
 t.name "Team Triumphant"
 t.email "triumphant@sv.cmu.edu"
 t.tigris_space "http://triumphant.tigris.org/servlets/ProjectDocumentList"
 t.twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
 t.person_name "Admin Andy"
 t.person_name2 "Faculty Frank"
 t.person_name3 "Student Sam"
 t.association :course, :factory => :course
end
