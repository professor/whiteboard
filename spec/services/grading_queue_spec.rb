# This spec is contributed by Team Turing
require 'spec_helper'
require_relative '../../app/services/grading_queue.rb'
#require_relative '../../spec/factories/users.rb'
#require_relative '../../spec/factories/teams.rb'
#require_relative '../../spec/factories/deliverables.rb'

describe GradingQueue do

  let(:class_with_grading_queue) {
    Class.new do
      include GradingQueue

    end
  }

  describe 'filtering grading queue' do

    before do

      @faculty = FactoryGirl.create(:faculty_snape_user)
      @team = FactoryGirl.create(:team_turing)
      @deliverable = FactoryGirl.create(:team_turing_deliverable)

    end

    it 'should be filtered by my students/teams and ungraded' do
      test_class = class_with_grading_queue.new
      test_class.deliverable_by_team.should == deliverable
    end

  end


end
