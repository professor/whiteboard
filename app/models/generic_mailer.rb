class GenericMailer < ActionMailer::Base
  

  def email(options = {})
    subject    options[:subject]
    recipients options[:to]
    from       options[:from] || 'scotty.dog@west.cmu.edu'
#    from       options[:from] || 'sedanospam@gmail.com'
    cc         options[:cc]
    bcc        options[:bcc]
    sent_on    Time.now
    body       :message => options[:message], :url => options[:url], :url_label => options[:url_label]
  end

end


