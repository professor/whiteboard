class RegistrationMailer < ActionMailer::Base
  default :from => "RailsAdmin@sv.cmu.edu"
  
  # This method notifies the listed faculty members of added students
  # faculty_emails:  A string list of faculty emails that need to be notified or a string Array of instructor emails. This field shouldn't be empty.  If so,
  #					 an error notification should be sent to the Rails Administrator or designated person.
  # students:		 An array of the added students. This array should have at least one entry and that is taken care of in the necessary controller action.
  # course:			 The Course object which the registration relates to. Since Registration is a nested resource to Courses, this should always be available.
  def notify_faculty_of_added_students(faculty_emails, students, course)
     unless faculty_emails.blank? || faculty_emails.empty? #if there is no assigned faculty to the course, do nothing
	    @students = students
		@course = course
		mail(:to => "kang.chen@sv.cmu.edu", :subject => "Students added to course")
	 else
	    # This is a placeholder for the error notification email for when students are added to a course without instructors identified for the course
	 end
  end
  
  # This method notifies the listed faculty members of dropped students
  # faculty_emails:  A string list of faculty emails that need to be notified or a string Array of instructor emails. This field shouldn't be empty.  If so,
  #					 an error notification should be sent to the Rails Administrator or designated person.
  # students:		 An array of the dropped students. This array should have at least one entry and that is taken care of in the necessary controller action.
  # course:			 The Course object which the registration relates to. Since Registration is a nested resource to Courses, this should always be available.  
  def notify_faculty_of_dropped_students(faculty_emails, students, course)
     unless faculty_emails.blank? || faculty_emails.empty?
	    @students = students
		@course = course
		mail(:to => "kang.chen@sv.cmu.edu", :subject => "Students have been dropped from course")
	 else
	    # This is a placeholder for the error notification email for when students are added to a course without instructors identifed for the course.
	 end
  end
end
