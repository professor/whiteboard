require 'spec_helper'

describe Person do

  Factory.define :john, :class => Person do |p|
    p.persistence_token   Time.now.to_f.to_s
    p.first_name          "John"
    p.last_name           "Smith"
    p.email               "john@smith.com"
    p.image_uri           "/images/mascot.jpg"
    p.photo               nil
  end

  it "photo upload is optional" do
    john = Factory(:john);
    john.should be_valid;
  end

  it "photo upload accepts PNG files" do
    john = Factory(:john);
    john.photo = File.new("spec/fixtures/sample_photo.png");
    john.should be_valid;
  end

  it "photo upload does not accept GIF files" do
    john = Factory(:john);
    john.photo = File.new("spec/fixtures/sample_photo.gif");
    john.should_not be_valid;
  end

  it "should update image_uri after photo is uploaded" do
    john = Factory(:john);
    john.photo = File.new("spec/fixtures/sample_photo.jpg");
    john.save!
    john.image_uri.should eql(john.photo.url)
  end
end

