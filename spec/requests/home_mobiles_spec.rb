require 'spec_helper'

describe "HomePage for Mobile", mobile: true do

  subject{page}

  describe "GET /index" do

    before {visit root_path(mobile:1)}

    it "should have navigation links" do
      subject.should have_selector('div#nav')
    end

    it 'should not have to navigation' do
      subject.should_not have_selector 'div#topnav'
    end
  end
end
