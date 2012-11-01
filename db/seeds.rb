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

  sleep(0.02)

  factory :prof_liu, :parent => :person do
    first_name "YC"
    last_name "Liu"
    human_name "YC Liu"
    email "kate.liu@sv.cmu.edu"
    is_staff 1
  end

  sleep(0.02)

  factory :prof_signh, :parent => :person do
    first_name "P"
    last_name "Signh"
    human_name "P Signh"
    email "prabhjot.singh@sv.cmu.edu"
    is_staff 1
  end

  sleep(0.02)

  factory :owen, :parent => :person do
    id 994
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "OwenChu"
    first_name "Owen"
    last_name "Chu"
    human_name "Owen Chu"
    email "owen.chu@sv.cmu.edu"
    webiso_account "owenchu@andrew.cmu.edu"
  end

  sleep(0.02)

  factory :david, :parent => :person do
    id 995
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

  sleep(0.02)

  factory :madhok, :parent => :person do
    id 996
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "MadhokShivaratre"
    first_name "Madhok"
    last_name "Shivaratre"
    human_name "Madhok Shivaratre"
    email "madhokshivaratre@sv.cmu.edu"
    webiso_account "madhok.shivaratre@andrew.cmu.edu"
  end

  sleep(0.02)

  factory :team_3amigos, :class => Team do
    name "Team 3 Amigos"
    email "fall-2012-team-3-amigos@west.cmu.edu"
    course_id 1
    after(:create) { |team|
      FactoryGirl.create(:owen, teams:[team])
      FactoryGirl.create(:david, teams:[team])
      FactoryGirl.create(:madhok, teams:[team])
    }
  end


  sleep(0.02)

  factory :prabhjot, :parent => :person do
    id 997
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "PrabhjotSingh"
    first_name "Prabhjot"
    last_name "Singh"
    human_name "Prabhjot Singh"
    email "fake.prabhjot.singh@sv.cmu.edu"
    webiso_account "prabhjos@andrew.cmu.edu"
  end

  sleep(0.02)

  factory :lydian, :parent => :person do
    id 998
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "LydianLee"
    first_name "Lydian"
    last_name "Lee"
    human_name "Lydian Lee"
    email "lydian.lee@sv.cmu.edu"
    webiso_account "tingyenl@andrew.cmu.edu"
  end

  sleep(0.02)

  factory :kate, :parent => :person do
    id 999
    is_student 1
    is_part_time 0
    graduation_year "2012"
    masters_program "SE"
    masters_track "Tech"
    twiki_name "KateLiu"
    first_name "Kate"
    last_name "Liu"
    human_name "Kate Liu"
    email "fake.kate.liu@sv.cmu.edu"
    webiso_account "fake.kate.liu@andrew.cmu.edu"
  end

  sleep(0.02)

  factory :team_leopard, :class => Team do
    name "Team Leopard"
    email "fall-2012-team-leopard@west.cmu.edu"
    course_id 1
    after(:create) { |team|
      FactoryGirl.create(:prabhjot, teams:[team])
      FactoryGirl.create(:lydian, teams:[team])
      FactoryGirl.create(:kate, teams:[team])
    }
  end

end

# set up course
course_fse = Factory.create(:fse)

# set up teams
fse_teams = []
fse_teams << Factory.create(:team_3amigos, :course_id=>course_fse.id)
fse_teams << Factory.create(:team_leopard, :course_id=>course_fse.id)

# set up assignments
assignments = []
2.times do # prepare team deliverables
  assignments << Factory.create(:assignment_seq, :course_id=>course_fse.id, is_team_deliverable: true, is_submittable: true)
end
2.times do # prepare individual deliverables
  assignments << Factory.create(:assignment_seq, :course_id=>course_fse.id, is_team_deliverable: false, is_submittable: true)
end
assignments << Factory.create(:assignment_seq, :course_id=>course_fse.id, is_submittable: false)

# set up registration and grades
fse_teams.each do |team|
  team.members.each do |team_member|
    Factory.create(:registration, :course_id=>course_fse.id, :user => team_member)
    assignments.each do |assign|
      Factory.create(:grade_seq, :course_id=>course_fse.id, :assignment => assign, :student_id => team_member.id)
    end
  end
end

prof_liu = Factory.create(:prof_liu)
Factory.create(:faculty_assignment, :course_id=>course_fse.id, :user_id=>prof_liu.id)

# set up another course
course_mfse = Factory.create(:mfse)
prof_signh = Factory.create(:prof_signh)
Factory.create(:faculty_assignment, :course_id=>course_mfse.id, :user_id=>prof_signh.id)


Factory(:task_type, :name => "Working on deliverables")
Factory(:task_type, :name => "Readings")
Factory(:task_type, :name => "Meetings")
Factory(:task_type, :name => "Other")


todd = Factory.create(:todd)
ed = Factory.create(:ed)
Factory.create(:team_terrific) #This will create awe_smith, betty_ross, and charlie_moss


Factory.create(:presentation_feedback_questions, :label => "Content", :text => "Did the talk cover all the content suggested on the checklist? (ie goals, progress, and the process for achieving the goals, outcomes)")
Factory.create(:presentation_feedback_questions, :label => "Organization", :text => "How logical was the organization? How smooth were transactions between points and parts of the talk?  Was the talk focused? To the point?  Were the main points clearly stated? easy to find?")
Factory.create(:presentation_feedback_questions, :label => "Visuals", :text => "Were they well-designed? Were all of them readable? Were they helpful? Were they manipulated well?")
Factory.create(:presentation_feedback_questions, :label => "Delivery", :text => "Bodily delivery: (eye-contact, gestures, energy)    Vocal delivery: (loudness, rate, articulation) Question handling (poise, tact, team support; did the team answer the question asked?)")


