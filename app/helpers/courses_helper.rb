module CoursesHelper
  def deliverable_grade_link_text(deliverable_grade)
    if deliverable_grade.blank?
      "Grade"
    else
      if deliverable_grade.deliverable.status == 'Graded'
        deliverable_grade.grade
      elsif deliverable_grade.deliverable.attachment_versions.blank?
        "Not Submitted"
      elsif deliverable_grade.deliverable.status == 'Ungraded'
        "Grade"
      else
        "#{deliverable_grade.grade} (#{deliverable_grade.deliverable.status})"
      end
    end
  end
end
