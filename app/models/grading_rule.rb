# GradingRule represents the correspondence between points earned and letter grades. The mapping rule is given by the
# course instructor.
#
# GradingRule is configurable by clicking on "Configure course" in "Initial Course Configuration", both of which could
# be found on the index page of each course. In the configuration page, professor can choose grading criteria between
#   points and letter grades. If professor adopts letter grades, then professor needs to fill the table which maps out
#   point and letter grades.
#
# GradingRule follows the grading policy of CMU@SV. We provide the following options for letter grades: A, A-, B+, B,
#   B-, C+, C, C-. These grades can be configured by faculty by going to course configuration page. Beside these grades
#   faculty can also enter R, W, I grades. But these grades are not configurable.
#
# We provide the following functions to map out points and letter grades.
# * validate_letter_grade performs letter grade validation for the given score.
# * validate_score performs score validation for the given score by the grade type
# * format_score formats the given score
# * get_grade_in_prof_format convert points to
# * grade_type tells whether the deliverable is graded by weight or by points
# * A_grade_min tells on or above this value the student will be marked as A-
# * A_minus_grade_min tells on or above this value the student will be marked as A
# * B_plus_grade_min tells on or above this value the student will be marked as B+
# * B_grade_min tells on or above this value the student will be marked as B
# * B_minus_grade_min tells on or above this value the student will be marked as B-
# * C_plus_grade_min tells on or above this value the student will be marked as C+
# * C_grade_min tells on or above this value the student will be marked as C
# * C_minus_grade_min tells on or above this value the student will be marked as C
# * course_id tells the course for which this grading rule exists
# * is_nomenclature_deliverable tells which name is preferred by professor (deliverable or assignment)


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

  def default_values?
    attribute_values = self.attributes.values
    attribute_values.include?(nil)
  end

  # To perform letter grade validation for the given score.
  def validate_letter_grade(raw_score)
    mapping_rule.has_key?(raw_score.to_s.upcase)
  end

  # To perform validation for the given score by the grade type
  def validate_score(raw_score)
    # allow users to skip entering grades
    if raw_score.nil? || raw_score.empty?
      return true
    end

    # allow users to enter letter grades
    if mapping_rule.has_key?(raw_score.to_s.upcase)
      return true
    end

    # return the grading type
    case grade_type
      when "points"
        return validate_points(raw_score)
      when "weights"
        return validate_weights(raw_score)
      else
        return false
    end
  end

  # To format the score is correct format before saving into the database.
  def self.format_score (course_id, raw_score)
    raw_score=raw_score.to_s
    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return raw_score
    elsif grading_rule.grade_type=="weights" && raw_score.end_with?("%")
      return raw_score.split("%")[0]
    else
      return raw_score
    end
  end

  # To get the grade type of the course, i.e. it is points or weights
  def self.get_grade_type (course_id)
    grading_rule = GradingRule.find_by_course_id(course_id)
    if grading_rule.nil?
      return "points"
    end

    return grading_rule.grade_type
  end

  # To get the grade parameters for calculating earned grade and final grade in the javascript.
  def get_grade_params_for_javascript
    weight_hash = []
    self.course.assignments.each do |assignment|
      score = assignment.maximum_score
      if self.grade_type == "weights"
        score *= 0.01
      end
      weight_hash << score
    end
    "'#{GradingRule.get_grade_type self.course_id}', #{mapping_rule.to_json}, #{weight_hash.to_json}"
  end

  # To get all of the valid letter grades.
  def letter_grades
    @letter_grades ||= mapping_rule.keys
  end

  private
  # To generate the mapping rule for converting grades into points
  def mapping_rule
    @mapping_rule = {}
    prev = 100
    ["A_grade_min", "A_minus_grade_min", "B_plus_grade_min", "B_grade_min", "B_minus_grade_min", "C_plus_grade_min", "C_grade_min", "C_minus_grade_min"].each do |attr_name|
      key = attr_name.gsub("_grade_min", "").gsub("_minus", "-").gsub("_plus", "+")
      @mapping_rule[key] = prev if attr_name =="A_grade_min"
      attr = self.read_attribute(attr_name)
      unless attr.nil?
        @mapping_rule[key] = prev
        prev = attr - 0.1 unless attr.nil?
      end
      ["R", "W", "I"].each do |attr|
        @mapping_rule[attr] = 0
      end
    end
    @mapping_rule
  end

  # To validate that the points given by faculty are correct
  def validate_points(raw_score)
    if raw_score.to_i<0
      return false
    end
    true if Float(raw_score) rescue false
  end

  # To validate that the score is a valid weight.
  def validate_weights(raw_score)
    if raw_score.end_with?("%")
      raw_score = raw_score.split('%')[0]
    end
    validate_points(raw_score)
  end

end