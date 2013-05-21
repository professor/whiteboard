class PasswordMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail :to => "to@example.org"
  end
end
