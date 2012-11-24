class ReminderMailer < ActionMailer::Base
  default :from => 'scotty.dog@sv.cmu.edu',
          :bcc => "rails.app@sv.cmu.edu"

  # Send email reminder.
  #
  # ==== Attributes
  #
  # * +options+ - Hash containing the following options:
  #
  # ==== Options
  #
  # * +:to+ - Email recipients like "user@sv.cmu.edu".
  # * +:subject+ - Subject of the email like "Friendly reminder".
  # * +:message+ - Message preceding the urls "Please update the following urls:".
  # * +:urls+ - Hash containing details about the urls to include like
  #   "{url_1 => url_label_1, url_2 => url_label_2}".
  def email(options = {})
    @to = options[:to]
    @message = options[:message]
    @urls = options[:urls]

    mail(:to => @to,
         :cc => options[:cc],
         :subject => options[:subject],
         :date => Time.now)
  end
end
