module TeamsHelper
  
  def twiki_user_link(twiki_username, human_name)
      "<a href='http://rails.sv.cmu.edu/people/#{twiki_username}' target='_top'>#{human_name}</a>"
  end

end
