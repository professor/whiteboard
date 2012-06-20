require 'spec_helper'
#require "cancan/matchers"

describe Person do

  before do
    User.delete_all
    # this list must not be sorted alphabetically
    @faculty_frank = FactoryGirl(:faculty_frank)
    @faculty_fagan = FactoryGirl(:faculty_fagan)
    @admin_andy = FactoryGirl(:admin_andy)
    @student_sam = FactoryGirl(:student_sam)
  end

#  describe "abilities" do
#    subject { ability }
#    let(:ability){ Ability.new(user) }
#
#
#    context "when is a contracts manager" do
#      let(:user){ FactoryGirl(:contracts_manager_user) }
#      it{ should be_able_to(:manage, SponsoredProjectAllocation.new) }
#      it{ should be_able_to(:manage, SponsoredProjectEffort.new) }
#      it{ should be_able_to(:manage, SponsoredProjectSponsor.new) }
#      it{ should be_able_to(:manage, SponsoredProject.new) }
#    end
#  end



  describe "user's teams" do

    it "should format teams" do
      @team_triumphant = FactoryGirl(:team_triumphant)
      teams = [@team_triumphant, @team_triumphant]
      subject.formatted_teams(teams).should == "Team Triumphant, Team Triumphant"
#      teams = [FactoryGirl(:team, :name => "Team Awesome"), FactoryGirl(:team, :name => "Team Beautiful")]
#      subject.formatted_teams(teams).should == "Team Awesome, Team Beautiful"
    end
  end

end
