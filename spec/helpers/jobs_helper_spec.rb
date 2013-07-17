require 'spec_helper'

describe JobsHelper do

  let(:job) { FactoryGirl.build(:job_with_supervisor_and_employee) }

  describe "Job person's names" do
    xit "should have a supervisor"
    # it "should have a method to get the names of supervisors if they exist" do
    #     expect(helper.job_person_names(job.job_supervisors)).to be_empty
    # end
  end

  describe "Closed jobs" do
    xit "should automatically convert jobs to not accepting if they get closed"
    xit "should not show closed jobs by default"
    xit "should also show closed jobs if show_all parameter is passed in"
  end

end
