Factory.define :sponsored_project, :class => SponsoredProject do |sp|
  sp.name 'Disaster Response'
  sp.association :sponsor, :factory => :sponsored_project_sponsor
end
