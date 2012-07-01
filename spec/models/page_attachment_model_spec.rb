require 'spec_helper'

describe PageAttachment do
  it { should belong_to :page }
  it { should have_attached_file :page_attachment }
  it { should belong_to :user }

  #context "is not valid" do
  #  [:readable_name, :user_id].each do |attr|
  #    it "without #{attr}" do
  #      subject.should_not be_valid
  #      subject.errors[attr].should_not be_empty
  #    end
  #  end
  #
  #  it "without is_active" do
  #    subject.is_active = nil
  #    subject.should_not be_valid
  #    subject.errors[:is_active].should_not be_empty
  #  end
  #end

  it "should be ordered" do
    
  end

it "once an attachment has been created, you can't change the name of the file. All subsequent replacements of that file will have the same name"

it "an attachment is versioned recording who made the change and any comments"

  # it "is versioned" do
  #  attachment =  FactoryGirl.create(:page_attachment)
  #  attachment.should respond_to(:version)
  #  attachment.save
  #  version_number = attachment.version
  #  attachment.readable_name = "A Nice New Name"
  #  attachment.save
  #  attachment.version.should == version_number + 1
  #end


#view stuff
it "there is an easy way to copy the link location of the file"
it "there is an accordian view of the attachments"

end
