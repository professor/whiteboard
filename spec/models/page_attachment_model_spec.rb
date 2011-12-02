require 'spec_helper'

describe PageAttachment do
  it { should belong_to :page }
  it { should have_attached_file :page_attachment }
end
