class EffortLogMailer < ActionMailer::Base
  

  def midweek_warning(saying, user)
    subject    "Scotty Dog says: #{saying}"
    recipients user.email
    #bcc        'todd.sedano@sv.cmu.edu'
    from       'scotty.dog@sv.cmu.edu'
    sent_on    Time.now
    
    body       :user => user
    
#    attachment :content_type => "image/jpeg",
#        :body => File.read(File.join(Rails.root, 'public', 'images', 'ScottyDogLandscape.jpg'))


  end


  def midweek_warning_admin_report(saying, people_without_effort, people_with_effort)
    subject    "Scotty Dog midweek warning email summary"
    #recipients ['todd.sedano@sv.cmu.edu', 'reed.letsinger@sv.cmu.edu', 'ed.katz@sv.cmu.edu', 'martin.radley@sv.cmu.edu']
    recipients  'aretha.kebirungi@sv.cmu.edu'
    from       'scotty.dog@sv.cmu.edu'
    sent_on    Time.now

    body       :saying => saying, :people_without_effort => people_without_effort, :people_with_effort => people_with_effort

#    attachment :content_type => "image/jpeg",
#        :body => File.read(File.join(Rails.root, 'public', 'images', 'ScottyDogLandscape.jpg'))

  end

   def endweek_admin_report(course_id, course_name, faculty_emails)
    subject    "Effort log data updated for #{course_name}"
    recipients faculty_emails
    from       'scotty.dog@sv.cmu.edu'
    #bcc        'todd.sedano@sv.cmu.edu'
    sent_on    Time.now

    body       :course_id => course_id, :course_name => course_name



  end


end


