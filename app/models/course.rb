class Course < ActiveRecord::Base
  has_many :teams
  belongs_to :course_number
  has_many :pages, :order => "position"

  has_and_belongs_to_many :people, :join_table=>"courses_people", :class_name => "Person"

  validates_presence_of :semester, :year, :mini, :name

  versioned
  validates_presence_of :updated_by_user_id
  belongs_to :updated_by, :class_name=>'User', :foreign_key => 'updated_by_user_id'


#  def to_param
#    self.short_name + self.semester + self.year.to_s
#  end

  def before_validation
     current_user = UserSession.find.user unless UserSession.find.nil?
     self.updated_by_user_id = current_user.id if current_user
  end

  named_scope :unique_course_numbers_and_names, :select => "DISTINCT number, name", :order => 'number ASC'

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

  def display_semester
    mini_text = self.mini == "Both" ? "" : self.mini + " "
    return self.semester + " " + mini_text + self.year.to_s
  end

  def self.remind_about_effort_course_list
    courses = Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), "both"] )
    courses = courses + Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), AcademicCalendar.current_mini] )
    return courses
  end

  def auto_generated_twiki_url
    return "http://info.sv.cmu.edu/do/view/#{self.semester}#{self.year}/#{self.short_or_full_name}/WebHome".delete(' ')
  end

  def auto_generated_peer_evaluation_date_start
    return Date.commercial(self.year,self.course_start + 6)
  end

  def auto_generated_peer_evaluation_date_end
   return Date.commercial(self.year, self.course_start + 7)
  end


  #Todo - create a test case for this
  #Todo - move to a higher class or try as a mixin
  def update_people(members)
    self.people = []
    return "" if members.nil?

    msg = ""
    members.each do |name|
       person = Person.find_by_human_name(name)
       if person.nil?
         all_valid_names = false
         msg = msg + "'" + name + "' is not in the database. "
         #This next line doesn't quite seem to work
         self.errors.add(:person_name, "Person " + name + " not found")
       else
         self.people << person
       end
    end
    return msg
  end


end
