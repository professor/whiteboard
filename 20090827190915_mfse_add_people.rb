class CreatePeople < ActiveRecord::Migration
  
  #People is a shadow model that allows us to create User records without going through the password verification. Since they have andrew accounts, they don't need passwords
  
  def self.up
    Person.create :twiki_name => "ToddSedano",      :is_staff => true, :first_name => "Todd", :last_name => "Sedano", :webiso_account => "at33@andrew.cmu.edu"
    Person.create :twiki_name => "EdKatz",          :is_staff => true, :first_name => "Ed", :last_name => "Katz", :webiso_account => "edkatz@andrew.cmu.edu"
    Person.create :twiki_name => "ReedLetsinger",   :is_staff => true, :first_name => "Reed", :last_name => "Letsinger", :webiso_account => "reedl@andrew.cmu.edu"
    Person.create :twiki_name => "MartinRadley",    :is_staff => true, :first_name => "Martin", :last_name => "Radley", :webiso_account => "mradley@andrew.cmu.edu"
    Person.create :twiki_name => "GladysMercier",   :is_staff => true, :first_name => "Gladys", :last_name => "Mercier", :webiso_account => "gmercier@andrew.cmu.edu"
    Person.create :twiki_name => "TonyWasserman",   :is_staff => true, :first_name => "Tony", :last_name => "Wasserman", :webiso_account => "aiw@andrew.cmu.edu"
    Person.create :twiki_name => "PatriciaCollins", :is_staff => true, :first_name => "Patricia", :last_name => "Collins", :webiso_account => "pcollins@andrew.cmu.edu"
    Person.create :twiki_name => "RayBareiss",      :is_staff => true, :first_name => "Ray", :last_name => "Bareiss", :webiso_account => "bareiss@andrew.cmu.edu"
    Person.create :twiki_name => "JazzAyvazyan",    :is_staff => true, :first_name => "Jazz", :last_name => "Ayvazyan", :webiso_account => "armena@andrew.cmu.edu", :is_admin => true
    Person.create :twiki_name => "JimMorris",       :is_staff => true, :first_name => "Jim", :last_name => "Morris", :webiso_account => "jhm@andrew.cmu.edu"
    Person.create :twiki_name => "MartinGriss",     :is_staff => true, :first_name => "Martin", :last_name => "Griss", :webiso_account => "griss@andrew.cmu.edu"
    
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2021", :masters_program => "SE", :masters_track => "DM", :twiki_name => "AweSmith", :first_name => "Awe", :last_name => "Smith", :image_uri => "/images/students/mascot.jpg", :webiso_account => "awesm@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2021", :masters_program => "SE", :masters_track => "DM", :twiki_name => "BettyRoss", :first_name => "Betty", :last_name => "Ross", :image_uri => "/images/students/mascot.jpg", :webiso_account => "bross@andrew.cmu.edu"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2021", :masters_program => "SE", :masters_track => "DM", :twiki_name => "CharlieMoss", :first_name => "Charlie", :last_name => "Moss", :image_uri => "/images/students/mascot.jpg", :webiso_account => "cmoss@andrew.cmu.edu"
  end


    @course = Course.create :course_number_id => 6, :name => "Architecture", :number => "96-705", :semester => "Summer", :mini => "Both", :year => "2008" 
    @reed = User.find_by_twiki_name("ReedLetsinger")
    
    Team.create :name => "Team Triumphant", :email => "triumphant@sv.cmu.edu", :tigris_space => "http://triumphant.tigris.org/servlets/Pro
jectDocumentList", :twiki_space => "http://info.sv.cmu.edu/twiki/bin/view/Graffiti/WebHome", :primary_faculty_id => @reed.id, :course_id => @course.id, :person_name => "Awe Smith", :person_name2 => "Betty Ross" , :person_name3 => "Charlie Moss"


  def self.down
  end
end
