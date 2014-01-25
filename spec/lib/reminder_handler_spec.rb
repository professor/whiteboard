require 'spec_helper'
require 'reminder_handler' #This line is required for Travis

describe ReminderHandler do
  context "while sending reminders for" do

    context "updating pages," do
      before :each do
        @current_time = Time.now
        @user = FactoryGirl.build_stubbed(:faculty_frank_user)
        # While storing to Active Record, use current_time.utc as Active record
        # assumes pacific time (config/application.rb) but stores as utc
        # internally. Causing the test case to fail.
        # Time zone overriden in (config/environments/test.rb)
        @page1 = FactoryGirl.build_stubbed(:ppm, updated_by_user_id: @user.id,
                                          updated_at: @current_time.utc - 1.year)
        @page2 = FactoryGirl.build_stubbed(:ppm, url: "page2",
                                          updated_by_user_id: @user.id,
                                          updated_at: @current_time.utc - 13.months)
        Page.stub(:all).and_return([@page1, @page2])
        @page1.stub(:updated_by).and_return(@user)
        @page2.stub(:updated_by).and_return(@user)
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
