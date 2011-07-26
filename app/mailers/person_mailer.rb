class PersonMailer < GenericMailer
  default :from => 'CMU-SV Official Communication <help@sv.cmu.edu>',
          :cc => 'help@sv.cmu.edu',
          :bcc => 'todd.sedano@sv.cmu.edu',
          :subject => 'Welcome to Carnegie Mellon University Silicon Valley'
          # Original default subject was - "Welcome to Carnegie Mellon University Silicon Valley (" + person.email + ")".
          #TO ASK - Person's email required in the subject?

  def welcome_email(person, password, options = {})
    @person = person
    @password = password

    # Original function signature - def welcome_email(welcome_email, person, password, options = {})
    #TO ASK - What is passed in welcome_email, a param for recipients in original function

    mail(:to => @person.email, :subject => options[:subject], :date => Time.now)
  end

end
