class AddPeopleErata < ActiveRecord::Migration
  def self.up
    Person.create :is_student => true, :is_part_time => true, :graduation_year => "2009", :masters_program => "SM", :twiki_name => "ManiaOrand", :first_name => "Mania", :last_name => "Orand", :image_uri => "/images/students/2009/SM/ManiaOrand.jpg", :webiso_account => "morand@andrew.cmu.edu"

    
  end

  def self.down
  end
end
