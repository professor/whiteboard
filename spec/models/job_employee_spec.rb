require 'spec_helper'

describe JobEmployee do

 describe "is protected against mass assignment" do
   it { should_not allow_mass_assignment_of(:user_id) }
   it { should_not allow_mass_assignment_of(:job_id) }
  end

end
