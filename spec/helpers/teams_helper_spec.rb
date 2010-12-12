require 'spec_helper'

describe TeamsHelper do
  describe "#twiki_user_link" do
      it "displays a link to the user's profile" do
        content = helper.twiki_user_link("AndrewCarnegie", "Andrew Carnegie")
        content.should include("<a href='http://rails.sv.cmu.edu/people/AndrewCarnegie'")
        content.should include("target='_top'")
        content.should include(">Andrew Carnegie</a>")
      end
    end
  end
