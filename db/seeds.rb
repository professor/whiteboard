# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)             


require 'factory_girl'

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

FactoryGirl.define do
  factory :todd, :parent => :person do
    first_name "Todd"
    last_name "Sedano"
    human_name "Todd Sedano"
    email "todd.sedano@sv.cmu.edu"
    is_staff 1
  end


  factory :ed, :parent => :person do
    first_name "Ed"
    last_name "Katz"
    human_name "Ed Katz"
    email "ed.katz@sv.cmu.edu"
    is_staff 1
  end

  factory :awe_smith, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2021"
    masters_program "SE"
    masters_track "DM"
    twiki_name "AweSmith"
    first_name "Awe"
    last_name "Smith"
    human_name "Awe Smith"
    image_uri "/images/mascot.jpg"
    email "awe.smith@sv.cmu.edu"
    webiso_account "awesm@andrew.cmu.edu"
  end

  factory :betty_ross, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2021"
    masters_program "SE"
    masters_track "DM"
    twiki_name "BettyRoss"
    first_name "Betty"
    last_name "Ross"
    human_name "Betty Ross"
    image_uri "/images/mascot.jpg"
    email "betty.ross@sv.cmu.edu"
    webiso_account "bross@andrew.cmu.edu"
  end

  sleep(0.02)

  factory :charlie_moss, :parent => :person do
    is_student 1
    is_part_time 1
    graduation_year "2021"
    masters_program "SE"
    masters_track "DM"
    twiki_name "CharlieMoss"
    first_name "Charlie"
    last_name "Moss"
    human_name "Charlie Moss"
    image_uri "/images/mascot.jpg"
    email "charlie.moss@sv.cmu.edu"
    webiso_account "cmoss@andrew.cmu.edu"
  end

  sleep(0.02)

#factory :architecture, :class => Course do |c|
# c.name "Architecture"
# c.number "96-705"
# c.semester "Summer"
# c.mini "Both"
# c.year "2008"
#end

  sleep(0.02)

  factory :team_terrific, :class => Team do
    name "Team Terrific"
    email "terrific@sv.cmu.edu"
    tigris_space "http://terrific.tigris.org/servlets/ProjectDocumentList"
    twiki_space "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome"
    association :course, :factory => :mfse_current_semester
    #after_create { |team| Factory(:awe_smith, :teams => [team])
    #Factory(:betty_ross, :teams => [team])
    #Factory(:charlie_moss, :teams => [team])
    #}
    after(:create) { |team|
      FactoryGirl.create(:awe_smith, teams:[team])
      FactoryGirl.create(:betty_ross, teams:[team])
      FactoryGirl.create(:charlie_moss, teams:[team])
    }

  end

  factory :your_name_here, :parent => :person do
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "DavidLiu"
    first_name "David"
    last_name "Liu"
    human_name "David Liu"
    email "david.liu@sv.cmu.edu"
    webiso_account "davidliu@andrew.cmu.edu"
  end

end

Factory(:task_type, :name => "Working on deliverables")
Factory(:task_type, :name => "Readings")
Factory(:task_type, :name => "Meetings")
Factory(:task_type, :name => "Other")

todd = Factory.create(:todd)
ed = Factory.create(:ed)
you = Factory.create(:your_name_here)
Factory.create(:team_terrific) #This will create awe_smith, betty_ross, and charlie_moss

architecture_course = Factory.create(:architecture_current_semester)
foundations_course = Factory.create(:foundations_current_semester)
ppm_course = Factory.create(:ppm_current_semester)

[architecture_course, foundations_course, ppm_course].each do |course|
  course.teams.first.members << you
  course.save
  course.assignments.each do |assignment|
    if assignment.team_deliverable
      deliverable = assignment.deliverables.find_by_team_id(Team.find_current_by_person_and_course(you, course).id)
      FactoryGirl.create(:deliverable_grade, user: you, deliverable: deliverable, grade: 0) unless deliverable.blank?
    else
      deliverable = FactoryGirl.create(:deliverable, creator: you, assignment: assignment)
      deliverable.attachment_versions << FactoryGirl.create(:deliverable_attachment, deliverable: deliverable, submitter: you, attachment_file_name: "attachment")
      assignment.deliverables << deliverable
    end
  end
  course.faculty_assignments << FactoryGirl.create(:faculty_assignment, user: todd, course: course)
end

Factory.create(:presentation_feedback_questions, :label => "Content", :text => "Did the talk cover all the content suggested on the checklist? (ie goals, progress, and the process for achieving the goals, outcomes)")
Factory.create(:presentation_feedback_questions, :label => "Organization", :text => "How logical was the organization? How smooth were transactions between points and parts of the talk?  Was the talk focused? To the point?  Were the main points clearly stated? easy to find?")
Factory.create(:presentation_feedback_questions, :label => "Visuals", :text => "Were they well-designed? Were all of them readable? Were they helpful? Were they manipulated well?")
Factory.create(:presentation_feedback_questions, :label => "Delivery", :text => "Bodily delivery: (eye-contact, gestures, energy)    Vocal delivery: (loudness, rate, articulation) Question handling (poise, tact, team support; did the team answer the question asked?)")
