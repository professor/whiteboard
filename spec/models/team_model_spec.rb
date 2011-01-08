require 'spec_helper'

describe Team do


  it "should throw an error when a google distribution list was not created" do
    google_apps_connection.stub(:create_group)
    google_apps_connection.stub(:add_member_to_group)
    
    team = Factory.create(:team_triumphant)
    lambda{team.update_google_mailing_list("new", "old", 123)}.should raise_error()



  end
  
end
