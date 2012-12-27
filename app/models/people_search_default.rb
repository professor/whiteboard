# If no search parameters were provided, the most useful default contacts for that user is shown.
# this is implemented in the people search pages
#
# == Related classes
# {Person Controller}[link:classes/PeopleController.html]
#
class PeopleSearchDefault < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :student_staff_group, :user_id

  def self.default_search_results(user)
    # Grab all records from the people_search_defaults table
    search_defaults = PeopleSearchDefault.all

    # Save "all" records for student_staff_group into results and reject from search_defaults list to move forward.
    results = search_defaults.find_all { |t| t.student_staff_group == 'All' }
    search_defaults.reject!  { |t| t.student_staff_group == 'All' }
    if(user.is_student)

      # Filter to only students
      search_defaults = search_defaults.find_all { |t| t.student_staff_group == 'Student' }

      # Save "all" records for program_group into results and reject from search_defaults list to move forward.
      search_defaults.find_all { |t| t.program_group == 'All' }.each { |x| results.push(x) }
      search_defaults.reject!  { |t| t.program_group == 'All' }

      # Filter to only students in same master program as user
      search_defaults = search_defaults.find_all { |t| t.program_group == user.masters_program }

      # Save "all" records for track_group into results and reject from search_defaults list to move forward.
      search_defaults.find_all { |t| t.track_group == 'All' }.each { |x| results.push(x) }
      search_defaults.reject!  { |t| t.track_group == 'All' }

      # Filter to only students in same master's track as user
      search_defaults = search_defaults.find_all { |t| t.track_group == user.masters_track || (user.masters_program == 'PhD' && t.track_group == nil) }.each { |x| results.push(x) }

    else
      # Filter to only staff and save
      search_defaults = search_defaults.find_all { |t| t.student_staff_group == 'Staff' }
      search_defaults.each { |x| results.push(x) }
    end
    # remove user if he would see himself and return.
    results.reject{ |t| t.user_id == user.id }
  end

end
