require 'spec_helper'

describe PageAttachment do

describe "Attributes" do
   before(:each) do
     @page_attachment = PageAttachment.new
   end
  it "should respond to name" do
     @page_attachment.should respond_to(:name)
  end

  it "should respond to a page id" do
    @page_attachment.should respond_to(:page_id)
  end

  it "should have an attachment" do
    @page_attachment.should respond_to(:attachment)
  end
end

describe "Verifies" do
  it "should have a name" do
    @page_attachment = PageAttachment.new(:name => "")
    @page_attachment.should_not be_valid

  end
end

end
