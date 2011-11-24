require File.join(Rails.root,'spec','factories','factories.rb')

Factory.define :registration do |r|
  r.association :course, :factory => :course
  r.association :person, :factory => :person
end
