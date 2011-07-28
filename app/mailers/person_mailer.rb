class PersonMailer < ActionMailer::Base
  default :from => 'CMU-SV Official Communication <help@sv.cmu.edu>',
          :cc => 'help@sv.cmu.edu',
          :bcc => 'todd.sedano@sv.cmu.edu',
          :subject => 'Welcome to Carnegie Mellon University Silicon Valley'

  def welcome_email(person, password, options = {})
    @person = person
    @password = password

    mail(:to => [@person.email, @person.personal_email],
         :subject => options[:subject] || "Welcome to Carnegie Mellon University Silicon Valley (" + @person.email + ")",
         :date => Time.now)
  end

end
