class PageCommentType < ActiveRecord::Base
  validates_presence_of :name, :background_color
end
