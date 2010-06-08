module TeamsHelper
  
  def twiki_user_link(twiki_username, human_name)
      "<a href='http://info.sv.cmu.edu/twiki/bin/view/Main/#{twiki_username}' target='_top'>#{human_name}</a>"
  end

# This method is now a partial ==> /people/_twiki_photo_link.erb
#  def twiki_photo_link(twiki_username, human_name, image_uri)
#      "<div class='team_member_photo'><a href='http://info.sv.cmu.edu/twiki/bin/view/Main/#{twiki_username}' target='_top'><%= image_tag(#{image_uri}, :border=>0, :width=>150, :height=>200, :alt=>"") %><img src='#{image_uri}' border=0 width=150 height=200></a><br><div class='label'>#{human_name}</div></div>"
#  end

  
 
end
