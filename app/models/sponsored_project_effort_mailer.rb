class SponsoredProjectEffortMailer < GenericMailer

  def monthly_staff_email(person, month, year, options = {})
    subject    options[:subject] || "Sponsored projects confirmation email for #{Date::MONTHNAMES[month]} #{year}"
    recipients options[:to] || person.email
    from       options[:from] || "hector.rastrullo@sv.cmu.edu"
    cc         options[:cc] || "hector.rastrullo@sv.cmu.edu"
    bcc        options[:bcc] || "todd.sedano@sv.cmu.edu"
    sent_on    Time.now
    body       :person => person, :month => month, :year => year
  end

end


