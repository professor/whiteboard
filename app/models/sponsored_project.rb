class SponsoredProject < ActiveRecord::Base
  validates_presence_of :name, :sponsor_id
  validates_uniqueness_of :name
  validates_inclusion_of :is_archived, :in => [true, false]

  named_scope :current, :conditions => {:is_archived => false}
  named_scope :archived, :conditions => {:is_archived => true}

  default_scope :order => "SPONSOR_ID ASC, NAME ASC"

  belongs_to :sponsor, :class_name => "SponsoredProjectSponsor"
end
