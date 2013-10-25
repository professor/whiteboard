class JobEmployee < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
  delegate :human_name, :to => :user
  delegate :twiki_name, :to => :user
end
