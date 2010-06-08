class AddIsTeacherToUser < ActiveRecord::Migration


  def self.up
    add_column :users, :is_teacher, :boolean
    add_column :users, :is_adobe_connect_host, :boolean
    
 #   self.modify_person "EdKatz"
 #   self.modify_person "ToddSedano"
 #   self.modify_person "ReedLetsinger"
 #   self.modify_person "RahulArora"
 #   self.modify_person "MartinRadley"
 #   self.modify_person "RayBareiss"
 #   self.modify_person "GladyMercier"
 #   self.modify_person "TonyWasserman"
 #   self.modify_person "PatriciaCollins"

  end

  def self.down
    remove_column :users, :is_teacher
    remove_column :users, :is_adobe_connect_host
  end

#private
#  def modify_person twiki_name
#    @person = User.find_by_twiki_name(twiki_name)
#    @person.is_staff = false
#    @person.is_teacher = true
#    @person.save!        
#  end  
  
end
