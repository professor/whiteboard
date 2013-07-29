module PeopleHelper

  def display_location(person)
    return nil if (person.work_city.nil? && person.work_state.nil? && person.work_country.nil?)
    return "#{person.work_state} #{person.work_country}" if person.work_city.nil?
    return "#{person.work_city}, #{person.work_state} #{person.work_country}"
  end

  def linked_in_path(person)
    return "http#{$2}://www.linkedin.com/in/#{$7}" if person.linked_in =~ /(http)?(s)?(:\/\/)?(www.)?(linkedin.com\/)?(.*\/)?(.*)/
    return "http://www.linkedin.com/in/#{person.linked_in}"
  end
  def facebook_path(person)
    return "http#{$2}://www.facebook.com/#{$7}" if person.facebook =~ /(http)?(s)?(:\/\/)?(www.)?(facebook.com\/)?(.*\/)?(.*)/
    return "http://www.facebook.com/#{person.facebook}"
  end
  def twitter_path(person)
    return "http#{$1}://www.twitter.com/#{$2}" if person.twitter =~ /\[http\]?(s)?:\/\/\]?\[www\.\]?twitter\.com\/(.*)\/?/
    return "http://www.twitter.com/#{person.twitter}"
  end
  def google_plus_path(person)
    return "http#{$2}://plus.google.com/#{$7}" if person.google_plus =~ /(http)?(s)?(:\/\/)?(www.)?(plus.google.com\/)?(.*\/)?(\d+)(.*)/
    return "http://plus.google.com/#{person.google_plus}"
  end
  def github_path(person)
    return "http#{$1}://www.github.com/#{$2}" if person.github =~ /\[http\]?(s)?:\/\/\]?\[www\.\]?github\.com\/(.*)\/?/
    return "http://www.github.com/#{person.github}"
  end

end
