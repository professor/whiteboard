require 'rubygems'
require 'rake'

namespace :cmu do
  namespace :sponsored_projects do
    desc "Do sponsored projects monthly_copy_to_sponsored_project_effort"
    task(:monthly_copy_to_sponsored_project_effort => :environment) do
      SponsoredProjectAllocation.monthly_copy_to_sponsored_project_effort
    end

    desc "Do sponsored projects emails_staff_requesting_confirmation_for_allocations"
    task(:emails_staff_requesting_confirmation_for_allocations => :environment) do
      SponsoredProjectAllocation.emails_staff_requesting_confirmation_for_allocations
    end
  end
end