#
# Note: paper is going away
#
#require 'spec_helper'
#
#describe Paper do
#
#  # before(:all) do
#  #     activate_authlogic
#  # end
#
#  it 'can be created' do
#    lambda {
#      Factory(:paper)
#    }.should change(Paper, :count).by(1)
#  end
#
#  context "is not valid" do
#    [:citation].each do |attr|
#      it "without #{attr}" do
#        subject.should_not be_valid
#        subject.errors[attr].should_not be_empty
#      end
#    end
#  end
#
#  it 'sets date and year upon initialization' do
#    paper = Paper.new()
#    paper.year.should == Date.today.year
#    paper.date.should == Date.today
#  end
#
#  context 'strips away whitespace and adds period before saving' do
#    before(:each) do
#      base = "text string"
#      no_period_and_trailing_whitespace = base + " "
#      no_period = base
#      @desired_end = base + "."
#      @variants = [no_period_and_trailing_whitespace, no_period, @desired_end]
#    end
#
#    it "on title" do
#      @variants.each do |variant|
#        paper = Factory.build(:paper)
#        paper.title = variant
#        paper.save
#        paper.title.should == @desired_end
#      end
#    end
#
#    it "on conference" do
#      @variants.each do |variant|
#        paper = Factory.build(:paper)
#        paper.conference = variant
#        paper.save
#        paper.conference.should == @desired_end
#      end
#    end
#
#    it "on authors_full_listing" do
#      @variants.each do |variant|
#        paper = Factory.build(:paper)
#        paper.authors_full_listing = variant
#        paper.save
#        paper.authors_full_listing.should == @desired_end
#      end
#    end
#  end
#end