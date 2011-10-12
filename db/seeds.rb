require 'factory_girl'

require File.join(Rails.root,'spec','factories','strength_themes.rb')
require File.join(Rails.root,'spec','factories','factories.rb')
Factory.create(:achiever)
Factory.create(:activator)
Factory.create(:adaptability)
Factory.create(:analytical)
Factory.create(:arranger)
Factory.create(:belief)
Factory.create(:command)
Factory.create(:communication)
Factory.create(:competition)
Factory.create(:connectedness)
Factory.create(:consistency)
Factory.create(:context)
Factory.create(:deliberative)
Factory.create(:developer)
Factory.create(:discipline)
Factory.create(:empathy)
Factory.create(:focus)
Factory.create(:futuristic)
Factory.create(:harmony)
Factory.create(:ideation)
Factory.create(:includer)
Factory.create(:individualization)
Factory.create(:input)
Factory.create(:intellection)
Factory.create(:learner)
Factory.create(:maximizer)
Factory.create(:positivity)
Factory.create(:relator)
Factory.create(:responsibility)
Factory.create(:restorative)
Factory.create(:self_assurance)
Factory.create(:significance)
Factory.create(:strategic)
Factory.create(:woo)

Factory.define :todd, :parent => :person  do |p|
  p.first_name "Todd"
  p.last_name "Sedano"
  p.human_name "Todd Sedano"
  p.email "todd.sedano@sv.cmu.edu"
  p.is_staff 1
  p.is_teacher 1
end

sleep(0.02)

Factory.define :ed, :parent => :person do |p|
  p.first_name "Ed"
  p.last_name "Katz"
  p.human_name "Ed Katz"
  p.email "ed.katz@sv.cmu.edu"
  p.is_staff 1
  p.is_teacher 1
end

sleep(0.02)

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

sleep(0.02)

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

sleep(0.02)

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

sleep(0.02)

#Factory.define :architecture, :class => Course do |c|
# c.name "Architecture"
# c.number "96-705"
# c.semester "Summer"
# c.mini "Both"
# c.year "2008"
#end

sleep(0.02)

Factory.define :team_terrific, :class => Team do |t|
  t.name "Team Terrific"
  t.email "terrific@sv.cmu.edu"
  t.tigris_space "http://terrific.tigris.org/servlets/ProjectDocumentList"
  t.twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
  t.association :course, :factory => :mfse_current_semester
  t.after_create {|team| Factory(:awe_smith, :teams => [team])
                         Factory(:betty_ross, :teams => [team])
                         Factory(:charlie_moss, :teams => [team])
                         }

end

Factory.define :your_name_here, :parent => :person do |p|
  p.is_student 1
  p.is_part_time 0
  p.graduation_year "2012"
  p.masters_program  "SE"
  p.masters_track  "Tech"
  p.twiki_name "FirstLast"
  p.first_name "First"
  p.last_name "Last"
  p.human_name "Your Name"
  p.email "your.email@sv.cmu.edu"
  p.webiso_account "your.name@andrew.cmu.edu"
end


Factory(:task_type, :name => "Working on deliverables")
Factory(:task_type, :name => "Readings")
Factory(:task_type, :name => "Meetings")
Factory(:task_type, :name => "Other")


todd = Factory.create(:todd)
ed = Factory.create(:ed)
Factory.create(:your_name_here)
Factory.create(:team_terrific) #This will create awe_smith, betty_ross, and charlie_moss



