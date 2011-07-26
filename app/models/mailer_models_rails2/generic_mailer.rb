class GenericMailer < ActionMailer::Base

  def email(options = {})
    subject    options[:subject]
    recipients options[:to]
    from       options[:from] || ENV['GMAIL_SMTP_USER'] || 'scotty.dog@sv.cmu.edu'
#    from       options[:from] || 'scotty.dog@sv.cmu.edu'
    cc         options[:cc]
    bcc        options[:bcc]
    sent_on    Time.now
    body       :message => options[:message], :url => options[:url], :url_label => options[:url_label]
  end

end



