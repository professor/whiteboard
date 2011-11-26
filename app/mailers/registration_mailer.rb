class RegistrationMailer < ActionMailer::Base
  default :from => "RailsAdmin@sv.cmu.edu"
  
  # This method notifies the listed faculty members of added students
  # faculty_emails:  A string list of faculty emails that need to be notified. Delimited by ";"
  # students: An array of the added students
  # course:   The Course object which the registration relates to.
  def notify_faculty_of_added_students(faculty_emails, students, course)
     unless faculty_emails.blank?  #if there is no assigned faculty to the course, do nothing
	    @students = students
		@course = course
		mail(:to => faculty_emails, :subject => "Students added to course")
	 end
  end
  
  # This method notifies the listed faculty members of dropped students
  # faculty_emails:  A string list of faculty emails that need to be notified. Delimited by ";"
  # students: An array of the dropped students
  # course:   The Course object which the registration relates to.
  def notify_faculty_of_dropped_students(faculty_emails, students, course)
     unless faculty_emails.blank?
	    @students = students
		@course = course
		mail(:to => faculty_emails, :subject => "Students have been dropped from course")
	 end
  end
end
