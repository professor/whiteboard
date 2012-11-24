require "spec_helper"
require "rake"

describe "User Profile Update Mailer" do
  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end


  it "should send a user an email if they have fields that need updating" do
    student_sam = FactoryGirl.create(:student_sam)


    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require "tasks/send_partial_profile_email"
    Rake::Task.define_task(:environment)
    @rake['cmu:update_user_profile_email'].invoke  

    ActionMailer::Base.deliveries.first.to.first.should == student_sam.email
    ActionMailer::Base.deliveries.first.parts.find {|p| p.content_type.match /html/}.body.raw_source.should =~ /Github
Organization Company
Personal Email
Pronunciation
Skype
Strength 1
Strength 2
Strength 3
Strength 4
Strength 5
Telephone
Organization Title
Work City
Work Country
Work State/

    ActionMailer::Base.deliveries.size.should == 1
  end
end
