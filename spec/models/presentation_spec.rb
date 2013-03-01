require 'spec_helper'

describe Presentation do
  it 'can be created' do
    lambda {
      FactoryGirl.create(:presentation)
    }.should change(Presentation, :count).by(1)
  end

  it 'can not be created if the team or individual are both emtpy' do
    lambda {
      FactoryGirl.create(:presentation, :team_id => nil, :user_id => nil)
    }.should raise_exception 
  end

  it 'should return true if the team owns the presentation' do
  	pres = FactoryGirl.build(:presentation)
  	pres.is_team_presentation?.should be_true
  end

  it 'should return false if the team does not own the presentation' do
  	pres = FactoryGirl.build(:presentation, :team_id => 134234)
  	pres.is_team_presentation?.should be_false
  end

  it 'should return the team name when the team owns the presentation' do
  	pres = FactoryGirl.build(:presentation)
  	pres.presenter.should == "Team"
  end

  it 'should return the human name when not the presentation is not owned by a team' do
  	sam = FactoryGirl.create(:student_sam)
  	pres = FactoryGirl.create(:presentation, :team_id => nil, :user_id => sam.id)
  	pres.presenter.should == "Student Sam"
  end

  it 'should return true when the current user is the presenter' do
  	sam = FactoryGirl.create(:student_sam_user)
  	pres = FactoryGirl.create(:presentation, :team_id => nil, :user_id => sam.id)
  	pres.presenter?(sam).should be_true
  end

  it 'should return false when the current user is not the presenter and not on the team' do
  	sam = FactoryGirl.build(:student_sam_user)
  	sally = FactoryGirl.build(:student_sally_user)
  	pres = FactoryGirl.build(:presentation, :team_id => nil, :user_id => sam.id)
  	pres.presenter?(sally).should be_false
  end

  it 'should return true when the current user is a member of a team who is the presenter' do
  	pres = FactoryGirl.build(:presentation)
  	pres.presenter?(pres.team.members.first).should be_true
  end

  it 'should return false when the current user is not a member of a team who is the presenter' do
  	sam = FactoryGirl.build(:student_sam_user)
  	pres = FactoryGirl.build(:presentation)
  	pres.presenter?(sam).should be_false
  end

  it 'should return true when the current user has given feedback' do
  	pres_fed_ans = FactoryGirl.build(:presentation_feedback_answer)
  	pres_fed_ans.feedback.presentation.has_given_feedback?(pres_fed_ans.feedback.evaluator).should be_true
  end

  it 'should return false when the current user has not given feedback' do
  	sally = FactoryGirl.build(:student_sally_user)
  	pres_fed_ans = FactoryGirl.build(:presentation_feedback_answer)
  	pres_fed_ans.feedback.presentation.has_given_feedback?(sally).should be_false
  end

  it 'should return a list of presentations that a presenter owns' do
  	sam = FactoryGirl.create(:student_sam_user)
  	pres = FactoryGirl.create(:presentation, :team_id => nil, :user_id => sam.id)
  	Presentation.find_by_presenter(sam).length.should == 1
  end

  it 'should return a list of presentations for a user that is on a team that owns the presentations' do
  	pres = FactoryGirl.create(:presentation)
  	Presentation.find_by_presenter(pres.team.members.first).length.should == 1
  end

  it 'should return an empty object for a user that is not on a team that owns the presentations and is not the owner' do
  	sally = FactoryGirl.build(:student_sally_user)
  	pres = FactoryGirl.build(:presentation)
  	Presentation.find_by_presenter(sally).should be_empty
  end  

  it 'should return a list of presentations for the given user and team if they are owned by the user or team' do
  	sam = FactoryGirl.create(:student_sam_user)
  	pres = FactoryGirl.create(:presentation, :user_id => sam.id)
  	Presentation.find_by_user_and_teams(sam, [pres.team]).length.should == 1
  end

  it 'should return a list of presentations for the given team if the team owns a presentation and user does not' do
  	sam = FactoryGirl.create(:student_sam_user)
  	sally = FactoryGirl.create(:student_sally_user)
  	pres = FactoryGirl.create(:presentation, :user_id => sam.id)
  	Presentation.find_by_user_and_teams(sally, [pres.team]).length.should == 1
  end

  it 'should return an empty object  for the given user and team if they are the owners of the presentaiton' do
  	sam = FactoryGirl.build(:student_sam_user)
  	sally = FactoryGirl.build(:student_sally_user)
  	pres = FactoryGirl.build(:presentation, :user_id => sam.id)
  	Presentation.find_by_user_and_teams(sally, []).should be_empty 
  end

  it 'should return true for a user who can see feedback on a presentation, for which he is the presenter' do
  	sam = FactoryGirl.create(:student_sam_user)
  	pres = FactoryGirl.create(:presentation, :user_id => sam.id)
  	pres.can_view_feedback?(sam).should be_true
  end

  it 'should return true for a user who is an admin and can see feedback on a presentation' do
  	sam = FactoryGirl.build(:student_sam_user)
  	andy = FactoryGirl.build(:admin_andy_user)
  	pres = FactoryGirl.build(:presentation, :user_id => sam.id)
  	pres.can_view_feedback?(andy).should be_true
  end

  it 'should return true for a user who is a faculty member and can see feedback on a presentation' do
  	sam = FactoryGirl.build(:student_sam_user)
  	frank = FactoryGirl.build(:faculty_frank_user)
  	pres = FactoryGirl.build(:presentation, :user_id => sam.id)
  	pres.can_view_feedback?(frank).should be_true
  end

  it 'should return false for a user who should not see feedback on a presentation' do
  	sam = FactoryGirl.build(:student_sam_user)
  	sally = FactoryGirl.build(:student_sally_user)
  	pres = FactoryGirl.build(:presentation, :user_id => sam.id)
  	pres.can_view_feedback?(sally).should be_false
  end

  it 'should return the user email that is registered in the team' do
  	sam = FactoryGirl.build(:student_sam_user)
  	pres = FactoryGirl.build(:presentation, :user_id => sam.id)
    pres.user_email.should == pres.team.email
  end

  it 'should return the user email when there is no teams' do
  	sam = FactoryGirl.create(:student_sam_user)
  	pres = FactoryGirl.create(:presentation, :team_id => nil, :user_id => sam.id)
  	pres.user_email.should == "student.sam@sv.cmu.edu"
  end

  it 'should deliver an email to the subject' do
  	sam = FactoryGirl.create(:student_sam_user)
  	pres = FactoryGirl.create(:presentation, :team_id => nil, :user_id => sam.id)
  	
  	expect {
  	message_text = pres.send_presentation_feedback_email("http://example.com")
  	message_text.header.to_s.should include "From: scotty.dog@sv.cmu.edu"
  	message_text.header.to_s.should include "To: student.sam@sv.cmu.edu"
  	message_text.header.to_s.should include "Feedback for presentation Test Presentation"
  	message_text.html_part.to_s.should include "See feedback for your presentation Test Presentation for Course"

  	message_text.html_part.to_s.should match /<a href=\"http:\/\/example.com\">View feedback<\/a>/

  	}.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

end

describe PresentationFeedback do
	it 'can be created' do
		lambda {
			FactoryGirl.create(:feedback_from_sam)
		}.should change(PresentationFeedback, :count).by(1)
	end
end

describe PresentationQuestion do
	it 'can be created' do
		lambda {
			FactoryGirl.create(:presentation_feedback_questions)
		}.should change(PresentationQuestion, :count).by(1)
	end

	it 'should return the existing questions that are not marked as deleted' do
		pres_fed_q1 = FactoryGirl.build(:presentation_feedback_questions, :text => "This is question 1")
		pres_fed_q2 = FactoryGirl.build(:presentation_feedback_questions, :text => "This is question 2")
		pres_fed_q2.deleted = true
		pres_fed_q2.save
		PresentationQuestion.existing_questions.should_not include pres_fed_q2
	end

	# it { should_not allow_mass_assignment_of(:deleted) }
end

describe PresentationFeedbackAnswer do
	it 'can be created' do
		lambda {
			FactoryGirl.create(:presentation_feedback_answer)
		}.should change(PresentationFeedbackAnswer, :count).by(1)
	end

	it 'can not be created without a rating' do
		lambda {
			FactoryGirl.create(:presentation_feedback_answer, :rating => nil)
		}.should raise_exception
	end	
end
