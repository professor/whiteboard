class Course < ActiveRecord::Base
  has_many :teams
  belongs_to :course_number
  has_many :pages, :order => "position"
  
  def semester_length
    if self.mini == "Both" then
      if semester == "Summer" then 
        return 12 
      else
        return 15
      end
    else 
      return 7
    end    
  end

  # Note that current_semester() logic is in application.rb
  def semester_start
    #Todo: refactor this code to check for self.year
    # these are for 2010
    if semester == "Spring" then
      return self.mini == "B" ? 9 : 2
    end
    if semester == "Summer" then
      return self.mini == "B" ? 26 : 20
    end
    if semester == "Fall" then
      return self.mini == "B" ? 41 : 34
    end
    # these are for 2009
#    if semester == "Spring" then
#      return self.mini == "B" ? 10 : 3
#    end
#    if semester == "Summer" then
#      return self.mini == "B" ? 27 : 21
#    end
#    if semester == "Fall" then
#      return self.mini == "B" ? 42 : 35
#    end
    return 0 #If the semester field isn't set
  end
  
  def semester_end
    self.semester_start + self.semester_length - 1
  end

  def sortable_value
    self.year.to_i * 100 + self.semester_end
  end

  def self.week_during_semester?(week_number)
    #These dates are for 2010
    case week_number
    when 0..1
      return false #before spring semester
    when 18..19
      return false #after spring, before summer semester
    when 32..33
      return false #summer break before fall semester
    when 50..53
      return false #winter break after fall semester
    else
      return true
    end
  end

  def display_name
    return self.name if self.short_name.blank?
    return self.name + " (" + self.short_name + ")"
  end

  def remind_about_effort
    return Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ?', Date.today.cwyear, ApplicationController.current_semester()] )
  end
  
end
