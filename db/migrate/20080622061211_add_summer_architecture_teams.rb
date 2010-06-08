class AddSummerArchitectureTeams < ActiveRecord::Migration
  def self.up
    @course = Course.create :course_number_id => 6, :name => "Architecture", :number => "96-705", :semester => "Summer", :mini => "Both", :year => "2008" 
    @reed = User.find_by_twiki_name("ReedLetsinger")
    @rahul = User.find_by_twiki_name("RahulArora")
    

    Team.create :name => "Team GoldenGate", :email => "sa-summer2008-team-goldengate@west.cmu.edu", :tigris_space => "http://summer-2008-pt-architecture-team1.tigris.org/servlets/ProjectDocumentList", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/Architecture/TeamGoldenGate/WebHome", :primary_faculty_id => @reed.id, :secondary_faculty_id => @rahul.id, :course_id => @course.id, :person_name => "Nicholas Lynn", :person_name2 => "Kenneth Ralph" , :person_name3 => "Nathan Chan", :person_name4 => "Poonam Gupta"
    Team.create :name => "Team Strauss", :email => "sa-summer2008-team-strauss@west.cmu.edu", :tigris_space => "http://summer-2008-pt-architecture-team2.tigris.org/servlets/ProjectDocumentList", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/Architecture/TeamStrauss/WebHome", :primary_faculty_id => @reed.id, :secondary_faculty_id => @rahul.id, :course_id => @course.id, :person_name => "John Rusnak", :person_name2 => "Grayson Deitering", :person_name3 => "Cheau Long Ng", :person_name4 => "Joshua Correa"
    Team.create :name => "Team AvantGarde", :email => "sa-summer2008-team-avantgarde@west.cmu.edu", :tigris_space => "http://summer-2008-pt-architecture-team3.tigris.org/servlets/ProjectDocumentList", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/Architecture/TeamAvantGarde/WebHome", :primary_faculty_id => @reed.id, :secondary_faculty_id => @rahul.id, :course_id => @course.id, :person_name => "Shreerang Sudame", :person_name2 => "Mario Campaz", :person_name3 => "Sirisha Pillalamarri", :person_name4 => "Amandeep Riar"
    Team.create :name => "Team Jebel", :email => "sa-summer2008-team-jebel@west.cmu.edu", :tigris_space => "http://summer-2008-pt-architecture-team4.tigris.org/servlets/ProjectDocumentList", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/Architecture/TeamJebel/WebHome", :primary_faculty_id => @reed.id, :secondary_faculty_id => @rahul.id, :course_id => @course.id, :person_name => "Arup Kanjilal", :person_name2 => "Majid AlShehry", :person_name3 => "Karthik Sankar", :person_name4 => "Dave Nugent"
    Team.create :name => "Team Winsome", :email => "sa-summer2008-team-winsome@west.cmu.edu", :tigris_space => "http://summer-2008-pt-architecture-team5.tigris.org/servlets/ProjectDocumentList", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/Architecture/TeamWinsome/WebHome", :primary_faculty_id => @reed.id, :secondary_faculty_id => @rahul.id, :course_id => @course.id, :person_name => "Harley Holliday", :person_name2 => "Neil Dave", :person_name3 => "Weimin Liu", :person_name4 => "Sam Pan"
    
  end

  def self.down
  end
end
