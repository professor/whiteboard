module UsersHelper

  #def twiki_user_link(twiki_username, human_name)
  #  if twiki_username.blank?
  #    "#{human_name}"
  #  else
  #    "<a href='http://rails.sv.cmu.edu/people/#{twiki_username}' target='_top'>#{human_name}</a>".html_safe
  #  end
  #end

  def linked_in_path(person)
    return "http://www.linkedin.com/in/#{$1}" if person.linked_in =~ /[https?:\/\/]?[www\.]?linkedin\.com\/in\/(.*)\/?/
    return "http://www.linkedin.com/in/#{person.linked_in}"
  end
  def facebook_path(person)
    return "http://www.facebook.com/#{$1}" if person.facebook =~ /[https?:\/\/]?[www\.]?facebook\.com\/(.*)\/?/
    return "http://www.facebook.com/#{person.facebook}"
  end
  def twitter_path(person)
    return "http://www.twitter.com/#{$1}" if person.twitter =~ /[https?:\/\/]?[www\.]?twitter\.com\/(.*)\/?/
    return "http://www.twitter.com/#{person.twitter}"
  end
  def google_plus_path(person)
    return "http://plus.google.com/u/1/#{$1}" if person.google_plus =~ /[https?:\/\/]?plus\.google\.com\/u\/1\/(.*)\/?/
    return "http://plus.google.com/u/1/#{person.google_plus}"
  end
  def github_path(person)
    return "http://www.github.com/#{$1}" if person.github =~ /[https?:\/\/]?[www\.]?github\.com\/(.*)\/?/
    return "http://www.github.com/#{person.github}"
  end

end
