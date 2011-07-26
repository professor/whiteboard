class SponsoredProjectEffortMailer < ActionMailer::Base 

  def monthly_staff_email(person, month, year, options = {})
    subject    options[:subject] || "Sponsored projects confirmation email for #{Date::MONTHNAMES[month]} #{year}"
    recipients options[:to] || person.email
    from       options[:from] || "hector.rastrullo@sv.cmu.edu"
    cc         options[:cc] || "hector.rastrullo@sv.cmu.edu"
    bcc        options[:bcc] || "todd.sedano@sv.cmu.edu"
    sent_on    Time.now
    body       :person => person, :month => month, :year => year
  end

  def changed_allocation_email_to_business_manager(person, month, year, options = {})
    subject    options[:subject] || "Action required: change in monthly allocations for #{person.human_name}"
    recipients options[:to] || "hector.rastrullo@sv.cmu.edu"
    from       options[:from] || "scotty.dog@sv.cmu.edu"
    bcc        options[:bcc] || "todd.sedano@sv.cmu.edu"
    sent_on    Time.now
    body       :person => person, :month => month, :year => year
  end


end


