class RegisteredCourse < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  belongs_to :person
  belongs_to :course
end

