require "spec_helper"

describe PasswordMailer do
  describe "password_reset" do
    let(:mail) { PasswordMailer.password_reset }

    it "renders the headers" do
      mail.subject.should eq("Password reset")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
