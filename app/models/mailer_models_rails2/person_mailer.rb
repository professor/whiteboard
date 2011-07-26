class PersonMailer < ActionMailer::Base 


  def welcome_email(welcome_email, person, password, options = {})
    subject    options[:subject] || "Welcome to Carnegie Mellon University Silicon Valley (" + person.email + ")"
    recipients options[:to] || welcome_email
    from       options[:from] || "CMU-SV Official Communication <help@sv.cmu.edu>"
    cc         options[:cc] || "help@sv.cmu.edu"
    bcc        options[:bcc] || "todd.sedano@sv.cmu.edu"
    sent_on    Time.now
    body       :person => person, :password => password
  end

end


