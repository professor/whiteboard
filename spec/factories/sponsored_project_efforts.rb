Factory.define :sponsored_project_effort, :class => SponsoredProjectEffort do |spe|
  spe.association :sponsored_projects_people, :factory => :sponsored_projects_people
  spe.current_allocation 10
  spe.year {Date.today.year}
  spe.month {Date.today.month}
  spe.confirmed false
end