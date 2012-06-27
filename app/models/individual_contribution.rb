class IndividualContribution < ActiveRecord::Base
  has_many :individual_contribution_for_courses, :dependent => :destroy
  belongs_to :user

  validates_presence_of :user_id
  validates_presence_of :week_number
  validates_presence_of :year


   def self.find_individual_contributions(current_user)
     where("user_id = ?", current_user.id).order("year DESC, week_number DESC")
   end

  def self.find_by_week(year, week_number, current_user)
    where("year = ? AND week_number = ? AND user_id = ? " , year, week_number, current_user.id).first
  end


  default_scope :order => "year DESC, week_number DESC"

  def combined_answers_for_courses
    answers_array = Array.new
    5.times.each do |i|
      answers_array[i] = Hash.new
    end
    individual_contribution_for_courses.each do |ic_course|
        answers_array[0].store(ic_course.course_id, ic_course.answer1)
        answers_array[1].store(ic_course.course_id, ic_course.answer2)
        answers_array[2].store(ic_course.course_id, ic_course.answer3)
        answers_array[3].store(ic_course.course_id, ic_course.answer4)
        answers_array[4].store(ic_course.course_id, ic_course.answer5)
    end
    answers_array
  end


  #def editable_by(current_user)
  #  if (current_user && current_user.is_admin?)
  #    return true
  #  end
  #  if (current_user && current_user.id == person_id)
  #    a = Date.today
  #    b = Date.commercial(self.year, self.week_number, 1)
  #    c = (Date.commercial(self.year, self.week_number, 7) + 1.day)
  #    if (Date.today >= Date.commercial(self.year, self.week_number, 1) && Date.today <= (Date.commercial(self.year, self.week_number, 7) + 1.day))
  #      return true
  #    end
  #  end
  #  return false
  #end
  #
  #def self.log_effort_week?(year, week_number)
  #  if AcademicCalendar.spring_break(year).include?(week_number)
  #    return false
  #  else
  #    return AcademicCalendar.week_during_semester?(year, week_number)
  #  end
  #end

end
