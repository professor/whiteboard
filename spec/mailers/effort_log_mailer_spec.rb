require "spec_helper"

describe EffortLogMailer do
  describe "midweek warning" do
    before(:each) do
      @student_sam = Factory(:student_sam)

    end
    it "should render successfully" do
      lambda {
        EffortLogMailer.midweek_warning("TURN IN YOUR HOURS",@student_sam)
      }.should_not raise_error
    end
    describe "rendered without error" do

          before(:each) do
            @mailer = EffortLogMailer.midweek_warning("TURN IN YOUR HOURS",@student_sam)
          end

          it "should send to the right person" do
            @mailer.To.to_s.should == "#{@student_sam.human_name} <#{@student_sam.email}>"
          end

          it "should have the right topic" do
            @mailer.Subject.to_s.should == "Scotty Dog says: TURN IN YOUR HOURS"
          end
          it "should BCC the right person" do
            @mailer.BCC.to_s.should == "todd.sedano@sv.cmu.edu"
          end
          it "should be from scotty dog" do
            @mailer.From.to_s.should == "scotty.dog@sv.cmu.edu"
          end
          it "should deliver successfully" do
            lambda { EffortLogMailer.deliver(@mailer) }.should_not raise_error
          end



        end

      end

  end
