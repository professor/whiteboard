module PeopleInACollection

  # When assigning faculty to a page, the user types in a series of strings that then need to be processed
  #:members_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the faculty association.

  def validate_members(override_symbol)
     override_list_of_strings = send(override_symbol)
     return "" if override_list_of_strings.nil?

     override_list_of_strings = remove_empty_fields(override_list_of_strings)
     send "#{override_symbol}=", override_list_of_strings

     override_list_of_users = map_member_strings_to_users(override_list_of_strings)
     override_list_of_users.each_with_index do |user, index|
       if user.nil?
         self.errors.add(:base, "Person " + override_list_of_strings[index] + " not found")
       end
     end
 	end

  def remove_empty_fields(list_of_strings)
    list_of_strings.select { |name| name != nil && name.strip != "" }
  end

  def map_member_strings_to_users(members_override_list)
    members_override_list.map { |member_name| User.find_by_human_name(member_name) }
  end

  # Example:
  #      include PeopleInACollection
  #      update_collection_members :supervisors_override, :supervisors, :update_log
  #
  #
  # override_symbol - the holds a string array of people's names
  # attribute_symbol - the association that needs to be updated
  # update_method_symbol - (optional) method to call with a list of added and removed users
  def update_collection_members override_symbol, attribute_symbol, update_method_symbol = nil
    override_list_of_strings = send(override_symbol)
    return "" if override_list_of_strings.nil?

    original_list_of_users = send "#{attribute_symbol}"
    original_list_of_strings = original_list_of_users.collect { |person| person.human_name }

    override_list_of_strings = remove_empty_fields(override_list_of_strings)
    send "#{override_symbol}=", override_list_of_strings

    override_list_of_users = map_member_strings_to_users(override_list_of_strings)
    added = added_people(override_list_of_users, original_list_of_users)
    removed = removed_people(override_list_of_users, original_list_of_users)

    raise "Error converting supervisors_override to IDs!" if override_list_of_users.include?(nil)
    send "#{attribute_symbol}=", override_list_of_users
    send "#{override_symbol}=", nil

    if update_method_symbol && (added.any? || removed.any?)
      send update_method_symbol, added, removed
    end
  end

  def detect_if_list_changed(override_list_of_strings, original_list_of_users)
    return (override_list_of_strings.sort != original_list_of_users.collect { |person| person.human_name }.sort)
  end

  def added_people(override_list_of_users, original_list_of_users)
    tmp =  (override_list_of_users - original_list_of_users)
    return tmp
  end

  def removed_people(override_list_of_users, original_list_of_users)
    tmp =  (original_list_of_users - override_list_of_users)
    return tmp
  end

end

