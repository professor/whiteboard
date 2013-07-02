module PeopleInACollection

  def validate_members(method_symbol)
     list_of_strings = send(method_symbol)
     return "" if list_of_strings.nil?

     set_method = "#{method_symbol}="
     send set_method, list_of_strings.select { |name| name != nil && name.strip != "" }

     list_of_users = map_member_strings_to_users(list_of_strings)
     list_of_users.each_with_index do |user, index|
       if user.nil?
         self.errors.add(:base, "Person " + list_of_strings[index] + " not found")
       end
     end
 	end

  def map_member_strings_to_users(members_override_list)
    members_override_list.map { |member_name| User.find_by_human_name(member_name) }
  end

end

