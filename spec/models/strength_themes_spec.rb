require 'spec_helper'

describe StrengthTheme do

  it 'can be created' do
    lambda {
      StrengthTheme.create(:theme => "Theme", :brief_description => "Lorem Ipsum", :long_description => "Longer Lorem Ipsum")
    }.should change(StrengthTheme, :count).by(1)
  end

  context "is not valid" do

    [:theme, :brief_description, :long_description].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end


end