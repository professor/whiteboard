class AddSummer2009EtimStudents < ActiveRecord::Migration
  def self.up

    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "ETIM", :masters_track => "", :twiki_name =>"KshamaNagaraja", :first_name => "Kshama", :last_name => "Nagaraja", :webiso_account => "knagaraj@andrew.cmu.edu", :image_uri => "/images/students/mascot.jpg"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "ETIM", :masters_track => "", :twiki_name =>"MaxwellThanhouser", :first_name => "Maxwell", :last_name => "Thanhouser", :webiso_account => "mthanhou@andrew.cmu.edu", :image_uri => "/images/students/mascot.jpg"
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2010", :masters_program => "MSE", :masters_track => "", :twiki_name =>"AbinShahab", :first_name => "Abin", :last_name => "Shahab", :webiso_account => "ashahab@andrew.cmu.edu", :image_uri => "/images/students/mascot.jpg"
    
    
  end

  def self.down
  end
end
