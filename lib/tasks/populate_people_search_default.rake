require 'rubygems'
require 'rake'

namespace :whiteboard do
  desc "One time script for populating data in the PeopleSearchDefault database"
  task(:populate_people_search_defaults => :environment) do
      [
       {:twiki_name => "ToddSedano", :student_staff_group => "Student", :program_group => "SE", :track_group => "Tech"},
       {:twiki_name => "ToddSedano", :student_staff_group => "Student", :program_group => "SE", :track_group => "DM"},
       {:twiki_name => "GladysMercier", :student_staff_group => "Student", :program_group => "SE", :track_group => "DM"},
       {:twiki_name => "GladysMercier", :student_staff_group => "Student", :program_group => "SM", :track_group => nil},
       {:twiki_name => "MartinGriss", :student_staff_group => "Student", :program_group => "PhD", :track_group => nil},
       {:twiki_name => "PatrickTague", :student_staff_group => "Student", :program_group => "INI", :track_group => nil},
       {:twiki_name => "MelRossoLlopart", :student_staff_group => "Student", :program_group => "INI", :track_group => nil},

       {:twiki_name => "MikelynnRomero", :student_staff_group => "Student", :program_group => nil, :track_group => nil},

       {:twiki_name => "MartinGriss", :student_staff_group => "Staff", :program_group => nil, :track_group => nil},
       {:twiki_name => "NgocHo", :student_staff_group => "Staff", :program_group => nil, :track_group => nil},
       {:twiki_name => "SylviaArifin", :student_staff_group => "Staff", :program_group => nil, :track_group => nil},

       {:twiki_name => "ToddSedano", :student_staff_group => "All", :program_group => nil, :track_group => nil},
       {:twiki_name => "JazzAyvazyan", :student_staff_group => "All", :program_group => nil, :track_group => nil},
       {:twiki_name => "StacyMarshall", :student_staff_group => "All", :program_group => nil, :track_group => nil},
       {:twiki_name => "TheresaDao", :student_staff_group => "All", :program_group => nil, :track_group => nil},
       {:twiki_name => "GerryPanelo", :student_staff_group => "All", :program_group => nil, :track_group => nil},
      ].each do |ps|
          u = User.find_by_twiki_name(ps[:twiki_name])
          PeopleSearchDefault.create!(:user_id => u.id, :student_staff_group => ps[:student_staff_group], :program_group => ps[:program_group], :track_group => ps[:track_group])
      end
  end

  desc "Helper script to clear the PS defaults"
  task(:clear_people_search_defaults => :environment) do
      PeopleSearchDefault.all.each {|ps| ps.destroy}
  end
end


