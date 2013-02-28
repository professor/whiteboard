require 'spec_helper'

describe PeerEvaluationController do
	context "a team member can" do
	    before do
	      @team = Factory.create(:team)
	      login(@team.members.first)
	    end

	    it "provide feedback" do
	    	lambda {
            	xhr :post, :complete_evaluation_update, {:id => @team.id, :peer_evaluation_review => {"0" => {"answer" => "The answer is 42"}}}
          	}.should change(PeerEvaluationReview,:count).by(1)

          	lambda {
	    		# {"allocations"=>{"1"=>"2"}, "id"=>"1"}
            	xhr :post, :complete_evaluation_update, {:id => @team.id, :allocations => {"0"=>"42"}}
          	}.should change(PeerEvaluationReview,:count).by(1)	
	    end
	end
end