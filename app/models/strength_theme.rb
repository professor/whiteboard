class StrengthTheme < ActiveRecord::Base

  validates_presence_of :theme
  validates_presence_of :brief_description
  validates_presence_of :long_description

end
