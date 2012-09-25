# Person is a versioned model representing user data. As described in the README,
# the Person model and the User model both represent the same database table.
#
# == Related classes
# {Person Controller}[link:classes/PeopleController.html]
#
# {User}[link:classes/User.html]
#
class Person < User
  set_table_name "users"


#  def to_param
#    if twiki_name.blank?
#      id.to_s
#    else
#      twiki_name
#    end
#  end


end
