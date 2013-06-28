module PeopleInACollection


	def validate_members(member_assignments_override)
    puts "\n\n\n******** Entering validate_members"

    puts "\n\n\n******** var member_assignments_override is #{member_assignments_override}"

    return "" if member_assignments_override.nil?

    puts "\n\n\n******** corssing return"

    send(self.member_assignments_override, member_assignments_override.select { |name| name != nil && name.strip != "" })
    list = map_member_strings_to_users(member_assignments_override)
    list.each_with_index do |user, index|
      if user.nil?
        self.errors.add(:base, "Person " + member_assignments_override[index] + " not found")
      end
    end
	end

  def map_member_stings_to_users(members_override_list)
    members_override_list.map { |member_name| User.find_by_human_name(member_name) }
  end



end

