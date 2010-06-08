class AddPeopleErrataMore < ActiveRecord::Migration
  def self.up
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "SE", :masters_track => "DM", :twiki_name =>"VineetAgarwal", :first_name => "Vineet", :last_name => "Agarwal", :image_uri => "/images/students/2009/SE/VineetAgarwal.jpg"    
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "SM", :twiki_name =>"KashifMehmood", :first_name => "Kashif", :last_name => "Mehmood", :image_uri => "/images/students/2009/SM/KashifMehmood.jpg"  
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "SM", :twiki_name =>"NancyZayed", :first_name => "Nancy", :last_name => "Zayed", :image_uri => "/images/students/2009/SM/NancyZayed.jpg"  
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "SM", :twiki_name =>"PrachinRanavat", :first_name => "Prachin", :last_name => "Ranavat", :image_uri => "/images/students/2009/SM/PrachinRanavat.jpg"   
  end

  def self.down
  end
end
