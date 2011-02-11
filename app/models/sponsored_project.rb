class SponsoredProject < ActiveRecord::Base
  validates_presence_of :name, :sponsor_id
  validates_uniqueness_of :name

  belongs_to :sponsor, :class_name => "SponsoredProjectSponsor"
end
