class Presentation < ActiveRecord::Base
  belongs_to :team
  belongs_to :course

end
