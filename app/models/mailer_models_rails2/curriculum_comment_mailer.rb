class CurriculumCommentMailer < ActionMailer::Base 
  

  def comment_update(curriculum_comment, status)
    subject    "Scotty Dog says: comment #{status} for your course"
#    recipients ['todd.sedano@sv.cmu.edu', 'reed.letsinger@sv.cmu.edu']
    recipients curriculum_comment.notify_instructors()
    bcc        'todd.sedano@sv.cmu.edu'
    from       'scotty.dog@sv.cmu.edu'
    sent_on    Time.now
    
    body       :curriculum_comment => curriculum_comment, :status => status
  end




end


