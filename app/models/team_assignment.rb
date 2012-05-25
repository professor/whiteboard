class TeamAssignment < ActiveRecord::Base
  belongs_to :user, :foreign_key => "person_id"
  belongs_to :team

  set_table_name "teams_people"
#  set_table_name "team_assignments"  #One day we'll be ready for this change


end
