require 'spec_helper'
require 'reminder_handler' #This line is required for Travis

describe ReminderHandler do
  context "while sending reminders for" do

    context "updating pages," do
      before :each do
        @user = FactoryGirl.create(:faculty_frank_user)
        @page = FactoryGirl.create(:ppm, updated_by_user_id: @user.id)
      end

      context "should include all pages that have been updated before the specified time" do
        subject { ReminderHandler.pages_to_update_by_user_id(Time.now) }
        it { should_not be_nil }
        it { should have_exactly(1).item }
        it { should have_key(@user.id) }
        it { should include(@user.id => [@page]) }
      end

      context "should not include pages that have been updated after the specified time" do
        subject { ReminderHandler.pages_to_update_by_user_id(1.day.ago) }
        it { should_not be_nil }
        it { should have_exactly(0).items }
        it { should_not have_key(@user.id) }
      end

      context "should include urls and labels of all specified pages" do
        subject { ReminderHandler.page_urls_with_labels([@page]) }
        it { should_not be_nil }
        it { should have_exactly(1).item }
        it { should have_key(Rails.application.routes.url_helpers::edit_page_url(@page.id,
                                                      :host => "whiteboard.sv.cmu.edu")) }
        it { should include(Rails.application.routes.url_helpers::edit_page_url(@page.id,
                                                      :host => "whiteboard.sv.cmu.edu") => @page.title) }
      end

      it "should send out an email to the user who last updated the page" do
        expect { ReminderHandler.send_page_update_reminders(Time.now)
               }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

  end
end