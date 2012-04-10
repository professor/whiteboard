#require "cancan/matchers"
#
#describe "User" do
#  describe "abilities" do
#    subject { ability }
#    let(:ability){ Ability.new(user) }
#
#
#    context "when is a contracts manager" do
#      let(:user){ Factory(:contracts_manager_user) }
#      it{ should be_able_to(:manage, SponsoredProjectAllocation.new) }
#      it{ should be_able_to(:manage, SponsoredProjectEffort.new) }
#      it{ should be_able_to(:manage, SponsoredProjectSponsor.new) }
#      it{ should be_able_to(:manage, SponsoredProject.new) }
#    end
#  end
#end
