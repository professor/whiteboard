require "spec_helper"

describe ReminderMailer do
  context "while reminding users" do
    before(:each) do
      @user = FactoryGirl.create(:faculty_frank_user)
      @page = FactoryGirl.create(:ppm, updated_by_user_id: @user.id)
      @options = {:to => @user.email,
                  :subject => "Reminder",
                  :message => "Reminder message",
                  :urls => {"http://whiteboard.sv.cmu.edu" => @page.title}}
    end

    it "should send email" do
      expect { ReminderMailer.email(@options).deliver
             }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
