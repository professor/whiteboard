class SponsoredProjectEffortMailer < ActionMailer::Base
  default :from => "hector.rastrullo@sv.cmu.edu",
          :cc => "hector.rastrullo@sv.cmu.edu",
          :bcc => "todd.sedano@sv.cmu.edu"

  def monthly_staff_email(person, month, year, options = {})
    @person = person
    @month = month
    @year = year

    mail(:to => options[:to] || @person.email,
         :subject => options[:subject] || "Sponsored projects confirmation email for #{Date::MONTHNAMES[month]} #{year}",
         :date => Time.now)
  end

  def changed_allocation_email_to_business_manager(person, month, year, options = {})
    @person = person
    @month = month
    @year = year

    mail(:to => options[:to] || @person.email,
         :subject => options[:subject] || "Action required: change in monthly allocations for #{@person.human_name}",
         :date => Time.now)
  end

end