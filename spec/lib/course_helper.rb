def create_individual_deliverable(assignment, creator)
  deliverable = FactoryGirl.create(:deliverable, creator: creator, assignment: assignment)
  deliverable.attachment_versions << FactoryGirl.create(:deliverable_attachment, deliverable: deliverable, submitter: creator, attachment_file_name: "attachment")
  assignment.deliverables << deliverable
end

def create_team_deliverable(assignment, team)
  deliverable = FactoryGirl.create(:deliverable, creator: team.members.first, team: team, assignment: assignment)
  deliverable.attachment_versions << FactoryGirl.create(:deliverable_attachment, deliverable: deliverable, submitter: team.members.first, attachment_file_name: "attachment")
  assignment.deliverables << deliverable
end