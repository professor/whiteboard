# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)             


require 'factory_girl'


FactoryGirl.create(:achiever)
FactoryGirl.create(:activator)
FactoryGirl.create(:adaptability)
FactoryGirl.create(:analytical)
FactoryGirl.create(:arranger)
FactoryGirl.create(:belief)
FactoryGirl.create(:command)
FactoryGirl.create(:communication)
FactoryGirl.create(:competition)
FactoryGirl.create(:connectedness)
FactoryGirl.create(:consistency)
FactoryGirl.create(:context)
FactoryGirl.create(:deliberative)
FactoryGirl.create(:developer)
FactoryGirl.create(:discipline)
FactoryGirl.create(:empathy)
FactoryGirl.create(:focus)
FactoryGirl.create(:futuristic)
FactoryGirl.create(:harmony)
FactoryGirl.create(:ideation)
FactoryGirl.create(:includer)
FactoryGirl.create(:individualization)
FactoryGirl.create(:input)
FactoryGirl.create(:intellection)
FactoryGirl.create(:learner)
FactoryGirl.create(:maximizer)
FactoryGirl.create(:positivity)
FactoryGirl.create(:relator)
FactoryGirl.create(:responsibility)
FactoryGirl.create(:restorative)
FactoryGirl.create(:self_assurance)
FactoryGirl.create(:significance)
FactoryGirl.create(:strategic)
FactoryGirl.create(:woo)

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
    name "Terrific"
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
end


FactoryGirl.create(:task_type, :name => "Working on deliverables")
FactoryGirl.create(:task_type, :name => "Readings")
FactoryGirl.create(:task_type, :name => "Meetings")
FactoryGirl.create(:task_type, :name => "Other")


todd = FactoryGirl.create(:todd)
ed = FactoryGirl.create(:ed)
FactoryGirl.create(:team_terrific) #This will create awe_smith, betty_ross, and charlie_moss


FactoryGirl.create(:presentation_feedback_questions, :label => "Content", :text => "Did the talk cover all the content suggested on the checklist? (ie goals, progress, and the process for achieving the goals, outcomes)")
FactoryGirl.create(:presentation_feedback_questions, :label => "Organization", :text => "How logical was the organization? How smooth were transactions between points and parts of the talk?  Was the talk focused? To the point?  Were the main points clearly stated? easy to find?")
FactoryGirl.create(:presentation_feedback_questions, :label => "Visuals", :text => "Were they well-designed? Were all of them readable? Were they helpful? Were they manipulated well?")
FactoryGirl.create(:presentation_feedback_questions, :label => "Delivery", :text => "Bodily delivery: (eye-contact, gestures, energy)    Vocal delivery: (loudness, rate, articulation) Question handling (poise, tact, team support; did the team answer the question asked?)")


