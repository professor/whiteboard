require 'spec_helper'

describe PageAttachment do
  it { should belong_to :page }
  it { should have_attached_file :page_attachment }
  it { should belong_to :user }
  it { should respond_to :readable_name }



it "once an attachment has been created, you can't change the name of the file. All subsequent replacements of that file will have the same name"

it "an attachment is versioned recording who made the change and any comments"


#view stuff
it "there is an easy way to copy the link location of the file"
it "there is an accordian view of the attachments"

end
