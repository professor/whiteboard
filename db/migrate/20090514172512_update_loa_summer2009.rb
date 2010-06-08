class UpdateLoaSummer2009 < ActiveRecord::Migration
  def self.up
    
    
    #LOA students Gayatri started in 2006 and so itsn't part of the system yet
  
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "SE", :masters_track => "DM", :twiki_name =>"GayatriPicha", :first_name => "Gayatri", :last_name => "Picha", :image_uri => "/images/students/2008/TechDM/GayatriPicha.jpg"

  end

  def self.down
  end
end
