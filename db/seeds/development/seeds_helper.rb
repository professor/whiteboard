def find_user(human_name, user)
  (User.find_by_human_name(human_name) || FactoryGirl.create(user))
end

def set_up_course(course)
  course.teams.each do |team|
    team.members.each do |team_member|
      FactoryGirl.create(:registration, :course_id=>course.id, :user => team_member)
    end
  end

  course.assignments.each do |assignment|
    if assignment.is_team_deliverable
      course.teams.each do |team|
        deliverable=FactoryGirl.create(:team_deliverable_simple, :team_id=>team.id, :creator_id=>team.members.first.id, :course_id=>course.id, :assignment_id=>assignment.id)
        FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>team.members.first.id, :attachment_file_name=>"#{team.name}_new_file", :submission_date=>Time.now)
        score = 1+Random.rand(assignment.maximum_score)
        team.members.each do |member|
          grade = FactoryGirl.create(:grade_points, :course_id=>course.id, :assignment => assignment, :student_id => member.id, :is_student_visible => true)
          grade.score = score
          grade.save
        end
      end
    elsif assignment.is_submittable
      course.registered_students.each do |student|
        deliverable=FactoryGirl.create(:individual_deliverable, :creator_id=>student.id, :course_id=>course.id, :assignment_id=>assignment.id)
        FactoryGirl.create(:deliverable_attachment, :deliverable_id=>deliverable.id, :submitter_id=>student.id, :attachment_file_name=>"#{student.human_name}_file", :submission_date=>Time.now)
        grade = FactoryGirl.create(:grade_points, :course_id=>course.id, :assignment => assignment, :student_id => student.id, :is_student_visible => true)
        grade.score = 1+Random.rand(assignment.maximum_score)
        grade.save
      end
    end
  end
end