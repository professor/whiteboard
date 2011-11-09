class RegisteredCourse < ActiveRecord::Base
  belongs_to :person
  belongs_to :course
end

