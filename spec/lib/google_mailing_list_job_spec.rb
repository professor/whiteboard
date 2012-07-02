require 'spec_helper'

describe GoogleMailingListJob do

#
# This is a carry over test from Team before the code was refactored into a lib
#
it "should throw an error when a google distribution list was not created" do
  ProvisioningApi.any_instance.stub(:create_group)
  ProvisioningApi.any_instance.stub(:add_member_to_group)
  ProvisioningApi.any_instance.stub(:delete_group)
  ProvisioningApi.any_instance.stub(:retrieve_all_members)
  ProvisioningApi.any_instance.stub(:retrieve_all_groups)

  team = FactoryGirl.create(:team_triumphant)
  lambda { team.update_google_mailing_list("new", "old", 123) }.should raise_error()
end


end
