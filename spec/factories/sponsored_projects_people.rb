Factory.define :sponsored_projects_people, :class => SponsoredProjectsPeople do |sp|
  sp.current_allocation 10
  sp.association :person, :factory => :student_sam
  sp.association :sponsored_project, :factory => :sponsored_project
end
