class JobEmployee < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :job
  belongs_to :user
  delegate :human_name, :to => :user
  delegate :twiki_name, :to => :user
end
