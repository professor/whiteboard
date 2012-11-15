# GradingRule represents the correspondence between points earned and letter grades. The mapping rule is given by the
# course instructor.
#
# GradingRule is configurable by clicking on "Configure course" in "Initial Course Configuration", on the index page of
# each course. In the configuration pate, professor can choose grading criteria between points and letter grades. If
# professor chooses using letter grades, professor would see a table that needs to be filled in the mapping rule between
# points and letter grades.
#
# As each course would have its own grading rule,
#
# We provides the following functions to facilitate the conversion between points and letter grades.
# * convert_points_to_letter_grade uses the grading rule to convert points to letter grades.
# * convert_letter_grade_to_points uses the grading rule to convert letter grades to points.
# * get_grade_in_prof_format returns the grade that follows grade configuration.
# * get_raw_grade returns points. If the grade type is letter, we will apply the grading rule to convert it to points.

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
                  :course_id,
                  :is_nomenclature_deliverable

  belongs_to :course

  def self.validate_letter_grade(raw_score)
    case raw_score
      when "A"
        return true
      when "A-"
        return true
      when "B+"
        return true
      when "B"
        return true
      when "B-"
        return true
      when "C+"
        return true
      when "C"
        return true
      when "C-"
        return true
      else
        return false
    end
  end

  def self.validate_points(raw_score)
     if raw_score.to_i<0
       return false
     end
    true if Float(raw_score) rescue false
  end

  def self.validate_percentage(raw_score)
    if raw_score.end_with?("%")
      raw_score = raw_score.split('%')[0]
    end
    return GradingRule.validate_points(raw_score)
  end

  def self.validate_score(course_id, raw_score)
    if raw_score.nil?
      return true
    end

    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return false
    end

    case grading_rule.grade_type
      when "points"
        return GradingRule.validate_points(raw_score)
      when "letter"
        return GradingRule.validate_letter_grade(raw_score)
      when "percentage"
        return GradingRule.validate_percentage(raw_score)
      else
        return true
    end
  end

  def self.format_score (course_id, raw_score)
    raw_score=raw_score.to_s
    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return raw_score
    elsif grading_rule.grade_type=="percentage" && raw_score.end_with?("%")
      return raw_score.split("%")[0]
    else
      return raw_score
   end
    #unless grading_rule.nil?
    #  case grading_rule.grade_type
    #    when "percentage"
    #     if raw_score.end_with?("%")
    #      return raw_score.split("%")[0]
    #    else
    #      return raw_score
    #  end
    #else
    #  return raw_score
    #end
  end

  # To convert points to letter grades
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

  # To convert letter grades to points
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

  # To get grade in the format that is configured by professor
  def self.get_grade_in_prof_format(course_id, raw_grade)
    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return raw_grade
    end

    case grading_rule.grade_type
      when "letter"
        return grading_rule.convert_points_to_letter_grade(raw_grade)
      when "points"
        return raw_grade
    end
  end

  # To get grade in points
  def self.get_raw_grade(course_id, grade)
    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return grade
    end

    case grading_rule.grade_type
      when "letter"
        return grading_rule.convert_letter_grade_to_points(grade)
      when "points"
        return grade
    end
  end
  def to_display
    unless self.is_nomenclature_deliverable?
      return "Assignment"
    else
      return "Deliverable"
    end
  end

  def self.get_grade_type (course_id)
    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return "points"
    end

    return grading_rule.grade_type

  end
end
