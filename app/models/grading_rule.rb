class GradingRule < ActiveRecord::Base
  attr_accessible :grade_type,
                  :A_grade_min,
                  :A_minus_grade_min,
                  :B_plus_grade_min,
                  :B_grade_min,
                  :B_minus_grade_min,
                  :C_plus_grade_min,
                  :C_grade_min,
                  :C_minus_grade_min,
                  :course_id

  belongs_to :course

  def convert_points_to_letter_grade (points)
    if points>=self.A_grade_min
      return "A"
    elsif points>=self.A_minus_grade_min
        return "A-"
    elsif points>=self.B_plus_grade_min
      return "B+"
    elsif points>=self.B_grade_min
      return "B"
    elsif points>=self.B_minus_grade_min
      return "B-"
    elsif points>=self.C_plus_grade_min
      return "C+"
    elsif points>=self.C_grade_min
      return "C"
    elsif points>=self.C_minus_grade_min
      return "C-"
    else
      return 0.to_s
    end
  end

  def convert_letter_grade_to_points (letter_grade)
    case letter_grade
      when "A"
        return 100.0
      when "A-"
        return (self.A_grade_min-0.1)
      when "B+"
        return (self.A_minus_grade_min-0.1)
      when "B"
        return (self.B_plus_grade_min-0.1)
      when "B-"
        return (self.B_grade_min-0.1)
      when "C+"
        return (self.B_minus_grade_min-0.1)
      when "C"
        return (self.C_plus_grade_min-0.1)
      when "C-"
        return (self.C_grade_min-0.1)
      else
        return -1.0
    end
  end

  def self.get_grade_in_prof_format(course_id, raw_grade)
    grading_rule = GradingRule.find_by_course_id(course_id)
    unless grading_rule.nil?
      case grading_rule.grade_type
        when "letter"
          return grading_rule.convert_points_to_letter_grade(raw_grade)
        when "points"
          return raw_grade
      end
    end
  end

  def self.get_raw_grade(course_id, grade)
    grading_rule = GradingRule.find_by_course_id(course_id)
    unless grading_rule.nil?
      case grading_rule.grade_type
        when "letter"
          return grading_rule.convert_letter_grade_to_points(grade)
        when "points"
          return grade
      end
    end
  end

end
