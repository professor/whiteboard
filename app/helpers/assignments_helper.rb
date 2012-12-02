module AssignmentsHelper

  def get_customised_name
    if @course.nil? || @course.grading_rule.nil? || @course.grading_rule.is_nomenclature_deliverable?
      return "Deliverable"
    else
      return "Assignment"
    end
  end

  def get_customised_grade_type
    if @course.nil? || @course.grading_rule.nil?
      return "Points"
    else
      if @course.grading_rule.grade_type=="weights"
        return "Weight"
      else
        return "Points"
        end
    end
  end

end
