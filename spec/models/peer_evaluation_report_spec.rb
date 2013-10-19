require 'spec_helper'

describe PeerEvaluationReport do
  describe "is protected against mass assignment" do
    it { should_not allow_mass_assignment_of(:team_id) }
    it { should_not allow_mass_assignment_of(:recipient_id) }
    it { should_not allow_mass_assignment_of(:email_date) }
  end
end

