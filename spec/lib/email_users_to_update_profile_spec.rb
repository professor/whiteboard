describe 'Email users to update their profile' do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @student_sam = FactoryGirl.create(:student_sam)
    @student_sam.last_sign_in_at = 1.day.ago
    @student_sam.github = 'samhub'
    @student_sam.save

    @student_sally = FactoryGirl.create(:student_sally)
    @student_sally.last_sign_in_at = 1.day.ago
    @student_sally.save
  end

  it "should send users emails" do
    @student_sam.notify_about_missing_fields
    ActionMailer::Base.deliveries.size.should == 1 #1 email for a missing skype account for sam
    @student_sally.notify_about_missing_fields
    ActionMailer::Base.deliveries.size.should == 3 #2 additional emails for a missing skype and github account for sally
  end

end