class PasswordMailer < ActionMailer::Base
  default :from => "whiteboard-noreply@#{GOOGLE_DOMAIN}"

  def password_reset(user)
    @user = user
    mail :to => user.personal_email, :subject => "Whiteboard Password Reset"
  end
end
