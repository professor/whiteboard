module PeopleInACollection


  def map_member_stings_to_users(members_override_list)
    members_override_list.map { |member_name| User.find_by_human_name(member_name) }
  end

  def validate_members(method_symbol)
     puts "\n\n\n******** Entering validate_members"

     list_of_strings = send(method_symbol)
     puts "\n\n\n******** var member_assignments_override is #{list_of_strings}"

     return "" if list_of_strings.nil?



     set_method = "#{method_symbol}="
     send set_method, list_of_strings.select { |name| name != nil && name.strip != "" }

     list_of_users = self.map_member_strings_to_users(list_of_strings)
     list_of_users.each_with_index do |user, index|
       if user.nil?
         self.errors.add(:base, "Person " + list_of_strings[index] + " not found")
       end
     end
 	end


	def validate_members_old(method_name, member_assignments_override)
    puts "\n\n\n******** Entering validate_members"

    puts "\n\n\n******** var member_assignments_override is #{member_assignments_override}"

    return "" if member_assignments_override.nil?

    list_of_strings = send(method_name, "")

    puts "\n\n\n******** var member_assignments_override is #{list_of_strings}"


    puts "\n\n\n******** corssing return"



    send(method_name, member_assignments_override.select { |name| name != nil && name.strip != "" })
    list_of_users = self.map_member_strings_to_users(member_assignments_override)
    list_of_users.each_with_index do |user, index|
      if user.nil?
        self.errors.add(:base, "Person " + member_assignments_override[index] + " not found")
      end
    end
	end




end

