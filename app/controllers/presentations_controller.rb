class PresentationsController < ApplicationController
  layout 'cmu_sv'

  before_filter :authenticate_user!

  def index_for_course
    @course = Course.find(params[:course_id])
    if (current_person.is_admin? || @course.faculty.include?(current_person))
      @presentations = Presentation.find_all_by_course_id(@course.id)
      p @presentations
    else
      has_permissions_or_redirect(:admin, root_path)
    end
  end



end
