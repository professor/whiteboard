class PeopleSearchDefault < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :student_staff_group, :user_id

  def default_search_results(user)
    search_defaults = PeopleSearchDefault.all
    results = search_defaults.find_all { |t| t.student_staff_group == 'All' }
    search_defaults.reject!  { |t| t.student_staff_group == 'All' }
    if(user.is_student)
      search_defaults = search_defaults.find_all { |t| t.student_staff_group == 'Student' }
      search_defaults.find_all { |t| t.program_group == 'All' }.each { |x| results.push(x) }
      search_defaults.reject!  { |t| t.program_group == 'All' }
      search_defaults = search_defaults.find_all { |t| t.program_group == user.masters_program }
      search_defaults.find_all { |t| t.track_group == 'All' }.each { |x| results.push(x) }
      search_defaults.reject!  { |t| t.track_group == 'All' }
      search_defaults = search_defaults.find_all { |t| t.track_group == user.masters_track || (user.masters_program == 'PhD' && t.track_group == nil) }.each { |x| results.push(x) }
    else
      search_defaults = search_defaults.find_all { |t| t.student_staff_group == 'Staff' }
      search_defaults.each { |x| results.push(x) }
    end
    user_objects = []
    results.each { |result| user_objects.push(result.user) }
    user_objects
  end

end
