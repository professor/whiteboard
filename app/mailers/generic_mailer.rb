class GenericMailer < ActionMailer::Base

  default :from => 'scotty.dog@sv.cmu.edu',
          :bcc => 'todd.sedano@sv.cmu.edu'

  def email(options = {})
    @to = options[:to]
    @message = options[:message]
    @url = options[:url]
    @url_label = options[:url_label]

    mail(:to => @to, :cc => options[:cc],
         :subject => options[:subject], :date => Time.now)
    #do |format|
    #  format.text { render :text => message }
#    end

  end


end