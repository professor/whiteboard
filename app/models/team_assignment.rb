class TeamAssignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  set_table_name "team_assignments" #One day we'll be ready for this change
end
