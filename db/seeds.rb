# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


require 'factory_girl'

FactoryGirl.define do
  factory :todd, :parent => :person do
    first_name "Todd"
    last_name "Sedano"
    twiki_name "ToddSedano"
    human_name "Todd Sedano"
    email "todd.sedano@sv.cmu.edu"
    is_staff 1
    image_uri "/images/staff/ToddSedano.jpg"
  end


  factory :ed, :parent => :person do
    first_name "Ed"
    last_name "Katz"
    twiki_name "EdKatz"
    human_name "Ed Katz"
    email "ed.katz@sv.cmu.edu"
    is_staff 1
    image_uri "/images/staff/EdKatz.jpg"
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
    twiki_name "FirstLast"
    first_name "First"
    last_name "Last"
    human_name "Your Name"
    email "your.email@sv.cmu.edu"
    webiso_account "your.name@andrew.cmu.edu"
  end

end

Factory(:task_type, :name => "Working on deliverables")
Factory(:task_type, :name => "Readings")
Factory(:task_type, :name => "Meetings")
Factory(:task_type, :name => "Other")


todd = Factory.create(:todd)
ed = Factory.create(:ed)
Factory.create(:your_name_here)
Factory.create(:team_terrific) #This will create awe_smith, betty_ross, and charlie_moss

FactoryGirl.create(:presentation_feedback_questions, :label => "Content", :text => "Did the talk cover all the content suggested on the checklist? (ie goals, progress, and the process for achieving the goals, outcomes)")
FactoryGirl.create(:presentation_feedback_questions, :label => "Organization", :text => "How logical was the organization? How smooth were transactions between points and parts of the talk?  Was the talk focused? To the point?  Were the main points clearly stated? easy to find?")
FactoryGirl.create(:presentation_feedback_questions, :label => "Visuals", :text => "Were they well-designed? Were all of them readable? Were they helpful? Were they manipulated well?")
FactoryGirl.create(:presentation_feedback_questions, :label => "Delivery", :text => "Bodily delivery: (eye-contact, gestures, energy)    Vocal delivery: (loudness, rate, articulation) Question handling (poise, tact, team support; did the team answer the question asked?)")


