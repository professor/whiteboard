class UpdateTaskTypes < ActiveRecord::Migration
  def self.up
#    TaskType.find_by_name("Administrative").destroy
#    TaskType.find_by_name("Teaching - Delivery").destroy
#    TaskType.find_by_name("Teaching - Development").destroy
#    TaskType.find_by_name("Student Supervision").destroy
#    TaskType.find_by_name("Research").destroy
#    TaskType.find_by_name("Marketing/Admissions").destroy
#    TaskType.find_by_name("Outreach").destroy
    
    TaskType.create :is_staff => true, :name => "Student Contact", :description => "Time spent in class sessions, meeting with teams, and answering emails."
    TaskType.create :is_staff => true, :name => "Grading / Review", :description => "Time spent providing feedback to the students on deliverables."
    TaskType.create :is_staff => true, :name => "Preparation", :description => "Time spent preparing for teaching activities. For example, completing the readings to become familiar with the material. Note: development should be assigned against a different project."
    TaskType.create :is_staff => true, :name => "Student Problems", :description => "Time spent dealing with problematic situations"
    TaskType.create :is_staff => true, :name => "Faculty Communication", :description => "Time spent coordinating with other faculty via email, phone calls, or meetings"
    TaskType.create :is_staff => true, :name => "Other", :description => "Any time spent on activities that is not included in the above categories."    
  end

  def self.down
    TaskType.find_by_name("Student Contact").destroy
    TaskType.find_by_name("Grading / Review").destroy
    TaskType.find_by_name("Preparation").destroy
    TaskType.find_by_name("Student Problems").destroy
    TaskType.find_by_name("Faculty Communication").destroy
    TaskType.find_by_name("Other").destroy
        
    TaskType.create :is_staff => true, :name => "Administrative", :description => ""
    TaskType.create :is_staff => true, :name => "Teaching - Delivery", :description => ""
    TaskType.create :is_staff => true, :name => "Teaching - Development", :description => ""
    TaskType.create :is_staff => true, :name => "Student Supervision", :description => ""
    TaskType.create :is_staff => true, :name => "Research", :description => ""
    TaskType.create :is_staff => true, :name => "Marketing/Admissions", :description => ""
    TaskType.create :is_staff => true, :name => "Outreach", :description => ""    
  end
end
