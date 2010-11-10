require 'factory_girl'


Factory.define :person, :class => Person do |p|
  p.is_staff 0
  p.is_active 1
  p.image_uri "/images/mascot.jpg"
end

Factory.define :todd, :parent => :person  do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Todd"
  p.last_name "Sedano"
  p.human_name "Todd Sedano"
  p.email "todd.sedano@sv.cmu.edu"
  p.is_staff 1
end

sleep(0.02)

Factory.define :martin, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Martin"
  p.last_name "Radley"
  p.human_name "Martin Radley"
  p.email "martin.radley@sv.cmu.edu"
  p.is_staff 1
end

sleep(0.02)

Factory.define :ed, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Ed"
  p.last_name "Katz"
  p.human_name "Ed Katz"
  p.email "ed.katz@sv.cmu.edu"
  p.is_staff 1
end

sleep(0.02)

Factory.define :chris, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Chris"
  p.last_name "Jensen"
  p.human_name "Chris Jensen"
  p.email "chris.jensen@sv.cmu.edu"
  p.is_student 1
end

sleep(0.02)

Factory.define :howard, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Howard"
  p.last_name "Huang"
  p.human_name "Howard Awesome Huang"
  p.email "howard.huang@sv.cmu.edu"
  p.is_student 1
end


Factory.define :awe_smith, :parent => :person do |p|
  p.is_student 1
  p.is_part_time 1
  p.graduation_year "2021"
  p.masters_program  "SE"
  p.masters_track  "DM"
  p.twiki_name "AweSmith"
  p.first_name "Awe"
  p.last_name "Smith"
  p.human_name "Awe Smith"
  p.image_uri "/images/mascot.jpg"
  p.email "awe.smith@sv.cmu.edu"
  p.webiso_account "awesm@andrew.cmu.edu"
end

Factory.define :betty_ross, :parent => :person do |p|
  p.is_student 1
  p.is_part_time 1
  p.graduation_year "2021"
  p.masters_program  "SE"
  p.masters_track  "DM"
  p.twiki_name "BettyRoss"
  p.first_name "Betty"
  p.last_name "Ross"
  p.human_name "Betty Ross"
  p.image_uri "/images/mascot.jpg"
  p.email "betty.ross@sv.cmu.edu"
  p.webiso_account "bross@andrew.cmu.edu"
end

Factory.define :charlie_moss, :parent => :person do |p|
  p.is_student 1
  p.is_part_time 1
  p.graduation_year "2021"
  p.masters_program  "SE"
  p.masters_track  "DM"
  p.twiki_name "CharlieMoss"
  p.first_name "Charlie"
  p.last_name "Moss"
  p.human_name "Charlie Moss"
  p.image_uri "/images/mascot.jpg"
  p.email "charlie.moss@sv.cmu.edu"
  p.webiso_account "cmoss@andrew.cmu.edu"
end



Factory.define :architecture, :class => Course do |c|
 c.name "Architecture"
 c.number "96-705"
 c.semester "Summer"
 c.mini "Both"
 c.year "2008"
end


Factory.define :team_triumphant, :class => Team do |t|
 t.name "Team Triumphant"
 t.email "triumphant@sv.cmu.edu"
 t.tigris_space "http://triumphant.tigris.org/servlets/ProjectDocumentList"
 t.twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
 t.person_name "Awe Smith"
 t.person_name2 "Betty Ross"
 t.person_name3 "Charlie Moss"
end



Factory.create(:todd)
martin = Factory.create(:martin)
Factory.create(:ed)
Factory.create(:chris)
Factory.create(:howard)
Factory.create(:awe_smith)
Factory.create(:betty_ross)
Factory.create(:charlie_moss)

architecture = Factory.create(:architecture)


Factory.create(:team_triumphant, :primary_faculty_id => martin.id, :course_id=> architecture)

