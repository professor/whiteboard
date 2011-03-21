class CurriculumCommentType < ActiveRecord::Base
  validates_presence_of :name, :background_color
end
