require 'spec_helper'

describe "effort_logs/new.html.erb" do
  before do
    assign(:day_labels, [1..7])
    course = FactoryGirl.create(:fse)
    assign(:courses, [course])
    assign(:task_types, [TaskType.create!])
    assign(:today_column, 1)
  end

  context 'with errors' do
    before do
	  @current_user = FactoryGirl.build(:faculty_frank)
      effort_log = EffortLog.new(:year => nil, :week_number => 12, :sum => 8, :user => @current_user)
      assign(:effort_log, effort_log)
      effort_log.valid?
    end
    it "renders any error messages" do
      render
      rendered.should have_selector("div#error_explanation")
    end
  end

  context 'without errors' do
    before do
	  @current_user = FactoryGirl.build(:faculty_frank)
      effort_log = EffortLog.new(:year => 2011, :week_number => 12, :sum => 8, :user => @current_user)
      assign(:effort_log, effort_log)
      effort_log.valid?
    end
    it 'does not render any error messages' do
      render
      rendered.should_not have_selector("div#error_explanation")
    end
  end

  context 'when the current user is an admin' do
    before do
      @current_user = FactoryGirl.create(:admin_andy)
      login(@current_user)
      effort_log = EffortLog.new(:year => 2011, :week_number => 12, :sum => 8, :user_id => @current_user.id)
      assign(:effort_log, effort_log)
    end
    it 'allows editing the person' do
      render
      rendered.should have_selector("input#effort_log_user_id")
    end
  end
end
