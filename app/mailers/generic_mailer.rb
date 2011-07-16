class GenericMailer < ActionMailer::Base

  default :from => 'scotty.dog@sv.cmu.edu'

  def email(options = {})
    @user = options[:to]
    @message = options[:message]
    @url = options[:url]
    @url_label = options[:url_label]

    mail(:to => @user.email, :cc => options[:cc], :bcc => options[:bcc],
         :subject => options[:subject], :date => Time.now)

  end

end