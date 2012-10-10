class GradeBook < ActiveRecord::Base
  attr_accessible :course, :student, :assignment
  belongs_to :course
  belongs_to :student, :class_name => "User"
  belongs_to :assignment
end

