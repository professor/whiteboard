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

  describe "GET 'config'" do
    it "should be successful" do
      get 'config'
      response.should be_success
    end
  end

end

