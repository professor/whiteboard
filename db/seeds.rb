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

Factory.define :martin, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Martin"
  p.last_name "Radley"
  p.human_name "Martin Radley"
  p.email "martin.radley@sv.cmu.edu"
  p.is_staff 1
end

Factory.define :ed, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Ed"
  p.last_name "Katz"
  p.human_name "Ed Katz"
  p.email "ed.katz@sv.cmu.edu"
  p.is_staff 1
end

Factory.define :chris, :parent => :person do |p|
  p.persistence_token Time.now.to_f.to_s
  p.first_name "Chris"
  p.last_name "Jensen"
  p.human_name "Chris Jensen"
  p.email "chris.jensen@sv.cmu.edu"
  p.is_student 1
end

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
  p.webiso_account "cmoss@andrew.cmu.edu"
end




Factory.create(:todd)
Factory.create(:martin)
Factory.create(:ed)
Factory.create(:chris)
Factory.create(:howard)
Factory.create(:awe_smith)
Factory.create(:betty_ross)
Factory.create(:charlie_moss)



