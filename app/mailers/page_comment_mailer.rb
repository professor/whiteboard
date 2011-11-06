class PageCommentMailer < ActionMailer::Base
  default :from => "scotty.dog@sv.cmu.edu",
          :bcc => "todd.sedano@sv.cmu.edu"

  def comment_update(curriculum_comment, status)
    @page_comment = curriculum_comment
    @status = status

    mail(:to => curriculum_comment.notify_instructors(),
         :subject => "Scotty Dog says: comment #{status} for your course",
         :date => Time.now)
  end

end
