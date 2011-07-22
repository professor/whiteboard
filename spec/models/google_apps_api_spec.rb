require 'spec_helper'

describe Person do

  #This test methods in the google_apps.rb file. These are global methods used sparingly through the code
  #Google has a limitation that requires authentication to be done using west accounts
  #In most of the code, we refer to email address as the sv account, however, in a few spaces
  #we need to use the west account when we are about to use the google api
  #
  #since these are global methods we test them here. It is tempting to put switch_sv_to_west on the person
  #object, but we really don't want the code base to know about this distinction.
  #
  #Another approach might be to do a mixin on google_api and override the api's method and do the replacement
  #as the method is being called. 
  it 'should convert sv email address to west' do
     switch_sv_to_west("andrew.carnegie@sv.cmu.edu").should == "andrew.carnegie@west.cmu.edu"
     switch_sv_to_west("andrew.carnegie@west.cmu.edu").should == "andrew.carnegie@west.cmu.edu"
     switch_sv_to_west("andrew.carnegie@sandbox.sv.cmu.edu").should == "andrew.carnegie@sandbox.sv.cmu.edu"
     switch_sv_to_west("andrew.carnegie@andrew.cmu.edu").should == "andrew.carnegie@andrew.cmu.edu"
     switch_sv_to_west("randomness").should == "randomness"
     switch_sv_to_west("").should == ""
     switch_sv_to_west(nil).should == nil
  end

  it 'should convert west email address to sv' do
     switch_west_to_sv("andrew.carnegie@sv.cmu.edu").should == "andrew.carnegie@sv.cmu.edu"
     switch_west_to_sv("andrew.carnegie@west.cmu.edu").should == "andrew.carnegie@sv.cmu.edu"
     switch_west_to_sv("andrew.carnegie@andrew.cmu.edu").should == "andrew.carnegie@andrew.cmu.edu"
     switch_west_to_sv("andrew.carnegie@sandbox.sv.cmu.edu").should == "andrew.carnegie@sandbox.sv.cmu.edu"
     switch_west_to_sv("randomness").should == "randomness"
     switch_west_to_sv("").should == ""
     switch_west_to_sv(nil).should == nil    
    
  end

end
