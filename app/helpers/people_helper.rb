module PeopleHelper

  def display_location(person)
    return nil if (person.work_city.nil? && person.work_state.nil? && person.work_country.nil?)
    return "#{person.work_state} #{person.work_country}" if person.work_city.nil?
    return "#{person.work_city}, #{person.work_state} #{person.work_country}"

  end


end
