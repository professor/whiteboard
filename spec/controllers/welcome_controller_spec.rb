require 'spec_helper'

describe WelcomeController do

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new_features'" do
    it "should be successful" do
      get 'new_features'
      response.should be_success
    end
  end

  describe "GET 'configuration'" do
    it "should be successful" do
      get 'configuration'
      response.should be_success
    end
  end

end

