require 'spec_helper'

describe Person do




  it "should allow for StrengthFinder/StrengthQuest themes" do
    subject.should respond_to(:strength1)
    subject.should respond_to(:strength2)
    subject.should respond_to(:strength3)
    subject.should respond_to(:strength4)
    subject.should respond_to(:strength5)

    user = Factory.build(:strength_quest)
    user.strength1.theme.should be_kind_of(String)
  end




end