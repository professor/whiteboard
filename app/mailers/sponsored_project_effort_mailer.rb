class SponsoredProjectEffortMailer < ActionMailer::Base
  default :from => "hector.rastrullo@sv.cmu.edu",
          :cc => ["hector.rastrullo@sv.cmu.edu", "ngoc.ho@sv.cmu.edu"],
          :bcc => "rails.app@sv.cmu.edu"

  def monthly_staff_email(user, month, year, options = {})
    @user = user
    @month = month
    @year = year

    mail(:to => options[:to] || @user.email,
         :subject => options[:subject] || "Sponsored projects confirmation email for #{Date::MONTHNAMES[month]} #{year}",
         :date => Time.now)
  end

  def changed_allocation_email_to_business_manager(user, month, year, options = {})
    @user = user
    @month = month
    @year = year

    mail(:to => options[:to] || @user.email,
         :subject => options[:subject] || "Action required: change in monthly allocations for #{@user.human_name}",
         :date => Time.now)
  end

end