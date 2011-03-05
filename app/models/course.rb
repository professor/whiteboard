class Course < ActiveRecord::Base
  has_many :teams
  belongs_to :course_number
  has_many :pages, :order => "position"

  def self.for_semester(semester, year)
    return Course.find(:all, :conditions => ["semester = ? and year = ?", semester, year], :order => "name ASC")
  end

  def self.current_semester_courses()
    return self.for_semester(AcademicCalendar.current_semester(),
                      Date.today.year)

  end

  def self.next_semester_courses()
    return self.for_semester(AcademicCalendar.next_semester(),
                             AcademicCalendar.next_semester_year())
  end


  def course_length
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

  def course_start
    start = AcademicCalendar.semester_start(semester, year)

    if semester == "Spring" then
      return self.mini == "B" ? start + 7 : start
    end
    if semester == "Summer" then
      return self.mini == "B" ? start + 6 : start
    end
    if semester == "Fall" then
      return self.mini == "B" ? start + 7 : start
    end
    return 0 #If the semester field isn't set
  end
  
  def course_end
    self.course_start + self.course_length - 1
  end

  def sortable_value
    self.year.to_i * 100 + self.course_end
  end

  def display_name
    return self.name if self.short_name.blank?
    return self.name + " (" + self.short_name + ")"
  end

  def short_or_full_name
    unless self.short_name.blank?
      self.short_name
    else
      self.name
    end
  end

  def self.remind_about_effort_course_list
    courses = Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), "both"] )
    courses = courses + Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), AcademicCalendar.current_mini] )
    return courses
  end
  
end
