class RegistrationMailer < ActionMailer::Base
  default :from => "RailsAdmin@sv.cmu.edu"
  
  # This method notifies the listed faculty members of added students
  # faculty_emails:  A string list of faculty emails that need to be notified. Delimited by ";"
  # students: An array of the added students
  # course:   The Course object which the registration relates to.
  def notify_faculty_of_added_students(faculty_emails, students, course)
     unless faculty_emails.blank?  #if there is no assigned faculty to the course, do nothing
		mail(:to => faculty_emails, :subject => "Students added to course #{course.name}")
	 end
  end
end
