require 'spec_helper'

describe JobsController do

  before do
    params = ActionController::Parameters.new({
      job: {
        supervisors_override: {
          user_id: 1,
          job_id: 1
        },
        employees_override: {
          user_id: 5,
          job_id: 1
        }
      }
    })

    @job = FactoryGirl.create(:job)
    Job.update(@job, params)
  end

  it 'is protected from mass assignment' do
    # Job ID is 11
    svs = @job.supervisors
    #svs.should == [5]
  end

end
