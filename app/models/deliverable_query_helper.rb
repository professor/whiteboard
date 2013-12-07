# This class is used to generate the Query that helps to fetch the result set
# for Grading Queue page for a professor or TA.
#
# Author - Surya Kiran
# Change log:
# 10/27 - Initial Add
# 11/06 - Improving query performance for team and individual deliverables
# 11/06 - Adding code comments
#

class DeliverableQueryHelper
  # This method will be called from the Model Class to generate the team deliverables query.
  # Depending on what options were selected for fetching the results, it calls the
  # get_team_deliverables_query method to prepare the actual custom SQL query.
  def self.generate_query_for_team_deliverables(course, current_user, team_selection)
    if team_selection == TeamSelection::MY_TEAMS
      faculty_id = current_user.id

      where_clause = " and (teams.primary_faculty_id = #{faculty_id} or teams.secondary_faculty_id = #{faculty_id}) "

      get_team_deliverables_query(course.id, where_clause)
    elsif team_selection == TeamSelection::ALL_TEAMS
      get_team_deliverables_query(course.id)
    end
  end

  # This method will be called from the Model Class to generate the individual deliverables query.
  # Depending on what options were selected for fetching the results, it calls the
  # get_individual_deliverables_query method to prepare the actual custom SQL query.
  def self.generate_query_for_individual_deliverables(course, current_user, team_selection)
    if team_selection == TeamSelection::MY_TEAMS
      where_clause = " where advisor_name = '#{current_user.human_name}' "

      get_individual_deliverables_query(course.id, where_clause)
    elsif team_selection == TeamSelection::ALL_TEAMS
      get_individual_deliverables_query(course.id)
    end
  end

  # This method populates the query based on the course and any custom where clause provided
  def self.get_team_deliverables_query(course_id, append_where_clause = '')
    sql_query = ' select distinct courses.name as course_name , assignments.task_number , ' +
        ' assignments.name as deliverable_name , teams.name as owner_name , ' +
        ' users.human_name as advisor_name , ' +
        ' case when grades.is_student_visible = \'t\' then \'graded\' ' +
        ' when grades.is_student_visible = \'f\' then \'drafted\' ' +
        ' when grades.is_student_visible is null then \'ungraded\' end as grading_status , ' +
        ' assignments.is_team_deliverable , deliverables.id as deliverable_id , ' +
        ' deliverables.team_id , deliverables.course_id , deliverables.assignment_id , ' +
        ' assignments.assignment_order ' +
        ' from teams join deliverables on deliverables.team_id = teams.id ' +
        '         and teams.course_id = deliverables.course_id ' +
        ' join team_assignments on teams.id = team_assignments.team_id ' +
        ' join assignments on deliverables.assignment_id = assignments.id ' +
        '         and assignments.course_id = deliverables.course_id ' +
        '         and assignments.course_id = teams.course_id' +
        ' join courses on courses.id = deliverables.course_id ' +
        '         and courses.id = assignments.course_id and courses.id = teams.course_id' +
        ' left outer join users on users.id = coalesce(teams.primary_faculty_id, teams.secondary_faculty_id) ' +
        ' left outer join grades on grades.course_id = deliverables.course_id ' +
        '         and grades.assignment_id = deliverables.assignment_id ' +
        '         and team_assignments.user_id = grades.student_id ' +
        ' where courses.id = ' + course_id.to_s + ' and assignments.is_submittable = \'t\' ' +
        '         and assignments.is_team_deliverable = \'t\' ' + append_where_clause +
        ' order by task_number, assignments.assignment_order, advisor_name, owner_name'

    return sql_query
  end

  # This method populates the query based on the course and any custom where clause provided
  def self.get_individual_deliverables_query(course_id, append_where_clause = '')
    sql_query = ' select * from  ' +
        ' (select student_deliverables.course_name , student_deliverables.task_number ,  ' +
        ' student_deliverables.deliverable_name , student_deliverables.owner_name ,  ' +
        ' student_coach_map.advisor_name , student_deliverables.grading_status ,  ' +
        ' student_deliverables.is_team_deliverable , student_deliverables.deliverable_id ,  ' +
        ' student_deliverables.team_id , student_deliverables.course_id ,  ' +
        ' student_deliverables.assignment_id , student_deliverables.assignment_order  ' +
        ' from (select courses.name as course_name , assignments.task_number ,  ' +
        '         assignments.name as deliverable_name , stud.id as student_id ,  ' +
        '         stud.human_name as owner_name ,  ' +
        '         case when grades.is_student_visible = \'t\' then \'graded\'  ' +
        '         when grades.is_student_visible = \'f\' then \'drafted\'  ' +
        '         when grades.is_student_visible is null then \'ungraded\' end as grading_status ,  ' +
        '         assignments.is_team_deliverable , deliverables.id as deliverable_id ,  ' +
        '         deliverables.team_id , deliverables.course_id , deliverables.assignment_id ,  ' +
        '         assignments.assignment_order  ' +
        '         from users stud join deliverables on deliverables.creator_id = stud.id  ' +
        '         left outer join courses on courses.id = deliverables.course_id  ' +
        #'         left outer join registrations on stud.id = registrations.user_id  ' +
        #'                 and registrations.course_id = courses.id  ' +
        '         left outer join assignments on assignments.course_id = courses.id  ' +
        '                 and assignments.id = deliverables.assignment_id  ' +
        '         left outer join grades on grades.course_id = courses.id  ' +
        '                 and grades.assignment_id = deliverables.assignment_id  ' +
        '                 and grades.student_id = stud.id  ' +
        '         where courses.id = ' + course_id.to_s + ' and stud.is_student = \'t\'  ' +
        '                 and assignments.is_submittable = \'t\'  ' +
        '                 and assignments.is_team_deliverable = \'f\' ) student_deliverables  ' +
        ' left join (select courses.id as course_id, courses.name as course_name,  ' +
        '                 prof.id as prof_id, prof.human_name as advisor_name, teams.id as team_id,  ' +
        '                 teams.name as team_name, stud.id as stud_id, stud.human_name as stud_name ' +
        '         from courses join teams on courses.id = teams.course_id  ' +
        '                 join team_assignments on teams.id = team_assignments.team_id  ' +
        '                 join users stud on stud.id = team_assignments.user_id  ' +
        '                 join users prof on prof.id = coalesce(teams.primary_faculty_id, teams.secondary_faculty_id) ' +
        '         where stud.is_student = \'t\' and courses.id = ' + course_id.to_s + ') student_coach_map  ' +
        ' on student_deliverables.student_id = student_coach_map.stud_id  ' +
        '         and student_deliverables.course_id = student_coach_map.course_id ' +
        ' order by task_number, assignment_order, advisor_name, owner_name) indi_deliv ' + append_where_clause

    return sql_query
  end
end

# ENum for Team Selection
class TeamSelection
  MY_TEAMS = 1
  ALL_TEAMS = 2
end

