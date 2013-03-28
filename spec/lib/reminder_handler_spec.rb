require 'spec_helper'
require 'reminder_handler' #This line is required for Travis

describe ReminderHandler do
  context "while sending reminders for" do

    context "updating pages," do
      before :each do
        @current_time = Time.now
        @user = FactoryGirl.create(:faculty_frank_user)
        @page1 = FactoryGirl.create(:ppm, updated_by_user_id: @user.id,
                                          updated_at: @current_time - 1.year)
        @page2 = FactoryGirl.create(:ppm, url: "page2",
                                          updated_by_user_id: @user.id,
                                          updated_at: @current_time - 13.months)
      end

      context "should only include pages that were last updated at the specified time (same day and month) in previous years" do
        subject { ReminderHandler.pages_to_update_by_user_id(@current_time) }
        it { should_not be_nil }
        it { should have_exactly(1).item }
        it { should have_key(@user) }
        it { should include(@user => [@page1]) }
      end

      context "should include urls and labels of all specified pages" do
        subject { ReminderHandler.page_urls_with_labels([@page1]) }
        it { should_not be_nil }
        it { should have_exactly(1).item }
        it { should have_key(Rails.application.routes.url_helpers::edit_page_url(@page1.id,
                                                      :host => "whiteboard.sv.cmu.edu")) }
        it { should include(Rails.application.routes.url_helpers::edit_page_url(@page1.id,
                                                      :host => "whiteboard.sv.cmu.edu") => @page1.title) }
      end

      it "should send out an email to the user who last updated the page" do
        expect { ReminderHandler.send_page_update_reminders(@current_time)
               }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

  end
end