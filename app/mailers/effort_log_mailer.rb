class EffortLogMailer < ActionMailer::Base

  default :from => 'scotty.dog@sv.cmu.edu',
          :bcc => "rails.app@sv.cmu.edu"

  def midweek_warning(saying, user)
    @user = user
    email_with_name = @user.human_name + ' <' + @user.email + '>'
    attachments["ScottyDogLandscape.jpg"] = Rails.application.assets.find_asset('ScottyDogLandscape.jpg')
    mail(:to => @user.email, :subject => "Scotty Dog says: #{saying}", :date => Time.now)

  end

  def endweek_admin_report(course_id, course_name, faculty_emails)
    @course_id = course_id
    @course_name = course_name

    mail(:to => faculty_emails, :subject => "Effort log data updated for #{course_name}", :date => Time.now)
  end

end



