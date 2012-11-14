module AssignmentsHelper

  def get_customised_name
    if @course.nil? || @course.grading_rule.nil? || @course.grading_rule.is_nomenclature_deliverable?
      return "Deliverable"
    else
      return "Assignment"
    end
  end
end
