module TeamsHelper
  
  def twiki_user_link(twiki_username, human_name)
      "<a href='http://info.sv.cmu.edu/twiki/bin/view/Main/#{twiki_username}' target='_top'>#{human_name}</a>"
  end

# This method is now a partial ==> /people/_twiki_photo_link.erb
#  def twiki_photo_link(twiki_username, human_name, image_uri)
#      "<div class='team_member_photo'><a href='http://info.sv.cmu.edu/twiki/bin/view/Main/#{twiki_username}' target='_top'><%= image_tag(#{image_uri}, :border=>0, :width=>150, :height=>200, :alt=>"") %><img src='#{image_uri}' border=0 width=150 height=200></a><br><div class='label'>#{human_name}</div></div>"
#  end
  def find_past_teams(person)
    @past_teams_as_member = Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND (c.semester <> ? OR c.year <> ?)", person.id, ApplicationController.current_semester(), Date.today.year])

    teams_list = ""
    count = 0
    @past_teams_as_member.each do |team|
      if count == 0
        teams_list = team.name
      else
        teams_list = teams_list.concat(", " + team.name)
      end
      count += 1
    end
    return teams_list
  end

  
 
end
