class AddSummerPracticumTeams < ActiveRecord::Migration
  def self.up
    @course = Course.create :course_number_id => 11, :name => "SE Practicum", :number => "96-710", :semester => "Summer", :mini => "Both", :year => "2008" 
    @ed_katz = User.find_by_twiki_name("EdKatz")

    Team.create :name => "Powers Of Two ", :email => "se-summer2008-team-powersoftwo@west.cmu.edu", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/SEPracticum/PowersOfTwo/WebHome", :tigris_space => "http://summer-2008-pt-practicum-team1.tigris.org/", :course_id => @course.id, :primary_faculty_id => @ed_katz.id
    Team.create :name => "mmSync", :email => "se-summer2008-team-mmSync@west.cmu.edu", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/SEPracticum/MmSync/WebHome", :tigris_space => "http://summer-2008-pt-practicum-team2.tigris.org", :course_id => @course.id, :primary_faculty_id => @ed_katz.id
    Team.create :name => "Plug & Go", :email => "se-summer2008-team-noclue@west.cmu.edu", :twiki_space => "http://info.west.cmu.edu/twiki/bin/view/Summer2008/SEPracticum/PlugAndGo/WebHome", :tigris_space => "http://summer-2008-pt-practicum-team3.tigris.org/", :course_id => @course.id, :primary_faculty_id => @ed_katz.id
    end

  def self.down
  end
end
